class TicketMailer < ApplicationMailer

    def ticket_added

        ticket_id = params[:ticket_id]
        @ticket_data = Ticket.find_by(id:ticket_id)
        
        @project_name = Project.find_by(id: @ticket_data.project_id).project_name
        
        @department_name = Department.find_by(id: @ticket_data.department_id).department_name
        

        attachments.inline['logo_v2.png'] = File.read(Rails.root.join("public/emails", "logo_v2.png"))
        attachments.inline['img1.png'] = File.read(Rails.root.join("public/emails", "img1.png"))
        attachments.inline['facebook.png'] = File.read(Rails.root.join("public/emails", "facebook.png"))
        attachments.inline['instagram.png'] = File.read(Rails.root.join("public/emails", "instagram.png"))
        attachments.inline['linkedin.png'] = File.read(Rails.root.join("public/emails", "linkedin.png"))
        attachments.inline['twitter.png'] = File.read(Rails.root.join("public/emails", "twitter.png"))
        attachments.inline['snapchat.png'] = File.read(Rails.root.join("public/emails", "snapchat.png"))
    
        mail(:to => "Santasamirz@gmail.com",:subject => "New Ticket Added - @ticket_data.subject")
    end

end
