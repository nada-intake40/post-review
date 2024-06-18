module SalaryHelper
    def calculated_basic_salary_and_allowances(salary_amount,commission_amount,nationality_id)
        basic_salary=salary_amount.to_f / 1.35
        hosting_allowance= basic_salary.to_f * 0.25
        transportation_allowance=basic_salary.to_f * 0.1
        gosi= nationality_id == 193 ? (salary_amount.to_f  / 9.75) : 0
        return {
            "basic_salary"=>(basic_salary.round(2)).to_f,
            "commission"=>(commission_amount.round(2)).to_f,
            "GOSI"=>(gosi.round(2)).to_f,
            "hosting_allowance"=>(hosting_allowance.round(2)).to_f,
            "transportation_allowance"=>(transportation_allowance.round(2)).to_f,
            
        }
    end

    def get_promoter_salary_per_month(data)
        salary_details=[]
        ##get last contract for promoter
        last_contract= Contract.find_by(id: data['contract_id'])
        total_salary=0
        days_off=get_number_of_days_off({'start_date'=>data['start_date'],'end_date'=>data['end_date'],'promoter_id'=>data['promoter_id'],'contract_start_date'=>data['contract_start_date'],'contract_end_date'=>data['contract_end_date']})
        custody=PromoterDeduction.where(promoter_id: data['promoter_id'],deduction_type_id: 1)
        .where("deduction_date between ? and ? ",data['start_date'],data['end_date']).select("ifnull(sum(deduction_amount),0) as deduction_amount")
        other_deductions=PromoterDeduction.where(promoter_id: data['promoter_id']).where("deduction_type_id != 1")
        .where("deduction_date between ? and ? ",data['start_date'],data['end_date']).select("ifnull(sum(deduction_amount),0) as deduction_amount")
        kpis=SalaryBonusValue.where(promoter_id: data['promoter_id'])
        .where("bonus_date  between ? and ? ",data['start_date'],data['end_date']).select("ifnull(sum(amount),0) as bouns_amount")

        if(data['salary_type_id'] !=2 )
            salary_details=calculated_basic_salary_and_allowances(data['salary_amount'],0,data['nationality_id'])
            if last_contract.present?
                gosi_amount = last_contract.gosi_amount  
                housing_allowance = last_contract.housing_allowance_amount
                transportation_allowance = last_contract.transport_allowance_amount
                salary_amount = last_contract.salary_amount
            else
                gosi_amount = salary_details['GOSI'] 
                housing_allowance = salary_details['hosting_allowance'] 
                transportation_allowance = salary_details['transportation_allowance']
                salary_amount = data['salary_amount']
            end
            salary_per_day=get_salary_per_day(data['salary_amount'])
            other_deductions[0]['deduction_amount']=(salary_per_day * days_off['unpaid_days_off']) + other_deductions[0]['deduction_amount'].to_f
            salary_for_all_working_days = (days_off['no_of_workings_days'].to_i + days_off['paid_days_off'].to_i) == (data['end_date'] - data['start_date']).to_i ? (salary_amount).to_f : (salary_per_day*(days_off['no_of_workings_days'].to_i + days_off['paid_days_off'].to_i)).to_f
            total_salary= salary_amount - gosi_amount 
        end

        total_salary=total_salary-other_deductions[0]['deduction_amount'].to_f  - custody[0]['deduction_amount'].to_f + kpis[0]['bouns_amount'].to_f + data['calculated_allowance'].to_f + data['additional_allowance'].to_f
       

        return {
            'no_of_working_days'=>days_off['no_of_workings_days'],
            'paid_days_off'=>days_off['paid_days_off'],
            'no_of_absence_days'=>days_off['unpaid_days_off'].to_i + days_off['paid_days_off'].to_i,
            'reason_days_off'=>days_off['reason_days_off'],
            'custody'=> (custody[0]['deduction_amount'].to_f).round(2),
            'GOSI'=>salary_details !=[] ? (gosi_amount).round(2) :  0.to_f,
            'KPIS'=>(kpis[0]['bouns_amount'].to_f).round(2),
            'deductions'=>(other_deductions[0]['deduction_amount'].to_f).round(2),
            'final_salary'=>(total_salary.to_f).round(2)
        }

    end

    def get_number_of_days_off(data)
        unpaid_days_off=0
        paid_days_off=0
        no_of_workings_days=0
        reason_days_off=[]
        reasons=nil
        for one_day in data['start_date']..data['end_date'] do
            promoters_paid_pays_off=PromoterOffDay.where(promoter_id: data['promoter_id'],day_off_reason_id: [1,4,3]).where("'#{one_day}' between DATE_ADD(Date(days_off_from), INTERVAL 1 DAY) and Date(days_off_to)").select("day_off_reason_id")
            paid_days_off=promoters_paid_pays_off != [] ? (paid_days_off+1) : paid_days_off
            promoters_un_paid_days_off=PromoterOffDay.where(promoter_id: data['promoter_id'],day_off_reason_id: [2]).where("'#{one_day}' between DATE_ADD(Date(days_off_from), INTERVAL 1 DAY) and Date(days_off_to)").select("day_off_reason_id")
            unpaid_days_off = promoters_un_paid_days_off != [] ? (unpaid_days_off + 1) : unpaid_days_off
            reason_days_off=promoters_paid_pays_off != [] ? reason_days_off << promoters_paid_pays_off[0]['day_off_reason_id'] : reason_days_off
            reason_days_off=promoters_un_paid_days_off != [] ? reason_days_off << promoters_un_paid_days_off[0]['day_off_reason_id'] : reason_days_off
            if(data['contract_start_date'] != nil && data['contract_end_date'] !=nil && promoters_paid_pays_off == [] && promoters_un_paid_days_off == [])
                if((data['contract_start_date']..data['contract_end_date']).cover?(one_day))
                    no_of_workings_days=no_of_workings_days+1
                end
            elsif(data['contract_start_date'] != nil && data['contract_end_date'] == nil && promoters_paid_pays_off == [] && promoters_un_paid_days_off == [])
                if((data['contract_start_date']..data['end_date']).cover?(one_day))
                    no_of_workings_days=no_of_workings_days+1
                end
            end
        end 
        if(reason_days_off != [])
            reasons=reason_days_off.uniq()
            reasons=DayOffReason.where(id: reasons).pluck(:day_off_reason_name).join(",")
        end
       
        return {

                'paid_days_off'=> paid_days_off,
                'unpaid_days_off'=>unpaid_days_off,
                'no_of_workings_days'=>no_of_workings_days,
                "reason_days_off"=>reasons

        }

    end

    def get_salary_per_day(salary)
        return ((salary).to_f/30).to_f
    end

    def format_salary_amount(salary_type_id,salary_amount,commission_amount)
        if(salary_type_id == 1)
			salary_amount = salary_amount.to_s
        elsif(salary_type_id == 2)
            salary_amount = (commission_amount.to_s  + '%')
        elsif(salary_type_id == 3)
            salary_amount=(salary_amount.to_s) + "," + (commission_amount.to_s  + '%')
        else
            salary_amount=salary_amount.to_s
        end
        return salary_amount
    end
end


