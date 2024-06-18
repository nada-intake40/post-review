module PromoterFileHelper
    def get_id_photos(promoter_id)
        img = []
        promoter_datail=PromoterDetail.where(promoter_id: promoter_id).first
        if(promoter_datail)
          if(promoter_datail.id_photos)
            if((promoter_datail.id_photos).include? ",")
              images=(promoter_datail.id_photos).split(',') 
              for image in images
                data="files/hr/ids/#{promoter_id}/#{image}"
		            img << data
              end
            else
              images=(promoter_datail.id_photos)
              data="files/hr/ids/#{promoter_id}/#{images}"
		          img << data
            end
          end
        end
        return img
    end
    
    def get_passport(promoter_id)
        img = []
        promoter_datail=PromoterDetail.where(promoter_id: promoter_id).first
        if(promoter_datail)
          if(promoter_datail.passport)
            if((promoter_datail.passport).include? ",")
              images=(promoter_datail.passport).split(',') 
              for image in images
                data="files/hr/passports/#{promoter_id}/#{image}"
                img << data
              end
            else
                images=(promoter_datail.passport) 
                data="files/hr/passports/#{promoter_id}/#{images}"
                img << data
            end
          end
        end
        return img
    end
    
    def get_cv(promoter_id)
        img = []
        promoter_datail=PromoterDetail.where(promoter_id: promoter_id).first
        if(promoter_datail)
          if(promoter_datail.cv)
            if((promoter_datail.cv).include? ",")
                images=(promoter_datail.cv).split(',') 
                for image in images
                data="files/hr/cvs/#{promoter_id}/#{image}"
                img << data
                end
            else
                images=(promoter_datail.cv)
                data="files/hr/cvs/#{promoter_id}/#{images}"

                img << data
            end
          end
        end
        return img
    end
    
    def get_last_certificate(promoter_id)
        img = []
        promoter_datail=PromoterDetail.where(promoter_id: promoter_id).first
        if(promoter_datail)
          if(promoter_datail.last_certificate)
            if((promoter_datail.last_certificate).include? ",")
              images=(promoter_datail.last_certificate).split(',') 
              for image in images
                data="files/hr/certificates/#{promoter_id}/#{image}"

                img << data
              end
            else
              images=(promoter_datail.last_certificate)
              data="files/hr/certificates/#{promoter_id}/#{images}"
              img << data
            end
          end
        end
        return img
    end
    
    def get_convenant(promoter_id)
        img = []
        promoter_datail=PromoterDetail.where(promoter_id: promoter_id).first
        if(promoter_datail)
          if(promoter_datail.convenant)
            if((promoter_datail.convenant).include? ",")
              images=(promoter_datail.convenant).split(',') 
              for image in images
                data="files/hr/convenants/#{promoter_id}/#{image}"
                img << data
              end
            else
              images=(promoter_datail.convenant)
              data="files/hr/convenants/#{promoter_id}/#{images}"
              img << data
            end
          end
        end
        return img
    end
    
    def get_bonds(promoter_id)
        img = []
        promoter_detail=PromoterDetail.where(promoter_id: promoter_id).first
        if(promoter_detail)
          if(promoter_detail.bonds)
            if((promoter_detail.bonds).include? ",")
              images=(promoter_detail.bonds).split(',') 
              for image in images
                data="files/hr/bonds/#{promoter_id}/#{image}"
                img << data
              end
            else
              images=promoter_detail.bonds
              data="files/hr/bonds/#{promoter_id}/#{images}"
              img << data
            end
          end
        end
        return img
    end
    def get_other_documents(promoter_id)
        img = []
        promoter_detail=PromoterDetail.where(promoter_id: promoter_id).first
        if(promoter_detail)
          if(promoter_detail.other_documents)
            if((promoter_detail.other_documents).include? ",")
              images=(promoter_detail.other_documents).split(',') 
              for image in images
                data="files/hr/other_documents/#{promoter_id}/#{image}"
                img << data
              end
            else
              images=promoter_detail.other_documents
              data="files/hr/other_documents/#{promoter_id}/#{images}"
              img << data
            end
          end
        end
        return img
    end
    
    def get_contract_images(promoter_id)
        img = []
        contract=Contract.where(id: (Contract.where(promoter_id: promoter_id).select("max(id)"))).first
        if(contract)
            if(contract.contract_images)
              if((contract.contract_images).include? ",")
                  images=(contract.contract_images).split(',') 
                  for image in images
                  data="files/hr/contracts/#{promoter_id}/#{contract.id}/#{image}"
                  img << data
                  end
              else
                  images=(contract.contract_images)
                  data="files/hr/contracts/#{promoter_id}/#{contract.id}/#{images}"
                  img << data
              end
            end
        end
        return img
    end
  
def get_resignation_file(promoter_id)
      img = nil
      contract=Contract.where(id: (Contract.where(promoter_id: promoter_id).select("max(id)"))).first
      if(contract)
          if(contract.resignation_file)
             img="contracts_resignation/#{contract.id}/#{contract.resignation_file}"
          end
      end
      return img
end
def get_clearance_file(promoter_id)
      img = nil
      contract=Contract.where(id: (Contract.where(promoter_id: promoter_id).select("max(id)"))).first
      if(contract)
          if(contract.clearance_file)
             img="contracts_clearance/#{contract.id}/#{contract.clearance_file}"
          end
      end
      return img
end

def get_followup_file(promoter_id)
      img = []
      promoter_datail=Contract.where(id: (Contract.where(promoter_id: promoter_id).select("max(id)"))).first
      if(promoter_datail)
        if(promoter_datail.followup_file)
          if((promoter_datail.followup_file).include? ",")
            images=(promoter_datail.followup_file).split(',') 
            for image in images
              data="files/hr/followups/#{promoter_id}/#{image}"
              img << data
            end
          else
            images=(promoter_datail.followup_file)
            data="files/hr/followups/#{promoter_id}/#{images}"
            img << data
          end
        end
      end
      return img
end

def get_job_offer_file(promoter_id)
    img = []
    promoter_datail=Contract.where(id: (Contract.where(promoter_id: promoter_id).select("max(id)"))).first
    if(promoter_datail)
      if(promoter_datail.job_offer_file)
        if((promoter_datail.job_offer_file).include? ",")
          images=(promoter_datail.job_offer_file).split(',') 
          for image in images
            data="files/hr/joboffers/#{promoter_id}/#{image}"
            img << data
          end
        else
          images=(promoter_datail.job_offer_file)
          data="files/hr/joboffers/#{promoter_id}/#{images}"
          img << data
        end
      end
    end
    return img
end

def get_national_address_file(promoter_id)
  img = []
  promoter_datail=PromoterDetail.where(promoter_id: promoter_id).first
  if(promoter_datail)
    if(promoter_datail.national_address_file)
      if((promoter_datail.national_address_file).include? ",")
        images=(promoter_datail.national_address_file).split(',') 
        for image in images
          data="files/hr/national_addresses/#{promoter_id}/#{image}"
          img << data
        end
      else
        images=(promoter_datail.national_address_file)
        data="files/hr/national_addresses/#{promoter_id}/#{images}"
        img << data
      end
    end
  end
  return img
end

    def get_image(promoter_id)
      promoter=Promoter.where(id: promoter_id).first
      if(promoter.image)
        img = "promoters/#{promoter.id}/#{promoter.image}"
      else
        img = nil
      end
      return img
    end
end
  
