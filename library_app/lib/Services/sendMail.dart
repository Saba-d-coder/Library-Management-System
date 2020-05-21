import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

sendMail(recipient,text) async {
  String username = 'libraryapp.proj@gmail.com'; //Email id
  String password = 'library@123'; //Email's password

  final smtpServer = gmail(username, password);
  // Creating the Gmail server

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(recipient) //recipent email
    ..subject = 'LibraryApp generated mail' //subject of the email
    ..text = text ;//body of the email

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString()); //print if the email is sent
  } on MailerException catch (e) {
    print('Message not sent. \n'+ e.toString()); //print if the email is not sent
  }
}