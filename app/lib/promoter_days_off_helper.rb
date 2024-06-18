module PromoterDaysOffHelper
  def get_remaining_days_off(promoter_id,contract_id,annuel_days_off_per_year)
    no_of_remaining_days_off=annuel_days_off_per_year
    remaining_days_off=0
    contract=Contract.where(id: contract_id).first
    start_date=contract.contract_type_id == 1 ? contract.contract_start_date : Date.parse((Date.today).strftime("%Y")+'-'+contract.contract_start_date.strftime("%m")+'-'+contract.contract_start_date.strftime("%d"))
    end_date= contract.contract_type_id == 1 ? contract.contract_end_date : (start_date+1.year)-1.day
    for one_day in start_date..end_date do
        promoters_paid_pays_off=PromoterOffDay.where(promoter_id: promoter_id,day_off_reason_id: 4).where("'#{one_day}' between DATE_ADD(Date(days_off_from), INTERVAL 1 DAY) and Date(days_off_to)")
        if(promoters_paid_pays_off != [])
            remaining_days_off=remaining_days_off+1
        end
        no_of_remaining_days_off=annuel_days_off_per_year-remaining_days_off
    end
    return no_of_remaining_days_off
  end


  
end
  