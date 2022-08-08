package com.de_b1.service
//
//import com.sendgrid.Method
//import com.sendgrid.Request
//import com.sendgrid.Response
//import com.sendgrid.SendGrid
//
//import com.sendgrid.helpers.mail.Mail
//import com.sendgrid.helpers.mail.objects.Content
//
//import com.sendgrid.helpers.mail.objects.Email
//
//
//
//
//class SendGridService {
//
//    fun sendEmail() {
//        val from = Email("")
//        val subject = "Sending with SendGrid is Fun"
//        val to = Email("test@example.com")
//        val content = Content("text/plain", "and easy to do anywhere, even with Java")
//        val mail = Mail(from, subject, to, content)
//
//        val sg = SendGrid(System.getenv("SENDGRID_API_KEY"))
//        val request = Request()
//        try {
//            request.setMethod(Method.POST)
//            request.setEndpoint("mail/send")
//            request.setBody(mail.build())
//            val response: Response = sg.api(request)
//            System.out.println(response.getStatusCode())
//            System.out.println(response.getBody())
//            System.out.println(response.getHeaders())
//        } catch (cause: Throwable) {
//            throw cause
//        }
//    }
//}