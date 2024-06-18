namespace :endInvalidateContract do
    task endContract: :environment do
        contracts=Contract.where.not(contract_end_date: nil).where(contract_status_id: 1,contract_type_id: 1).where("contract_end_date < ?",Date.today)
        if(contracts != [])
            for contract in contracts
                Contract.where(id: contract.id).limit(1).update(contract_status_id: 2)
                if(contract.promoter.promoter_status_id == 2)
                    Promoter.where(id: contract.promoter_id).limit(1).update(promoter_status_id: 4)
                end

            end
        end
        
    end
    
end
