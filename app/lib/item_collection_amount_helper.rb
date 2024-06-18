module ItemCollectionAmountHelper
    def handle_collection_amount_for_invoice_devices(invoice_id,promoter_id)
        invoice_devices=InvoiceDevice.joins(invoice: {retail_company_branch: :retail_company}).where({retail_companies: {project_id: 10} })
        .where(invoice_id: invoice_id).select("invoice_devices.*")
        if(invoice_devices != [])
            for invoice_device in invoice_devices
                total_debit=(invoice_device.quantity).to_i * (invoice_device.collection_amount).to_f
                promoter=Promoter.where(id: promoter_id).first
                total_debit=(promoter.total_debit).to_f - total_debit.to_f
                Promoter.where(:id => promoter_id).limit(1).update_all(total_debit: total_debit.to_f) 
            end
        end

    end
end