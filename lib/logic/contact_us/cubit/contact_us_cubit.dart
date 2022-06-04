import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiftapp/data/models/staff.dart';
import '../../../data/repositories/common/common_repositories.dart';
import '../../../data/repositories/signup/signup_repository.dart';

class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsFailure extends ContactUsState {
  final String? error;

  const ContactUsFailure({this.error});

  @override
  List<Object> get props => [error ?? ""];
}

class ContactUsSuccess extends ContactUsState {}

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsInitial());

  Future ContactUs({
    required String subject,
    required String message,
    required Staff staff,
  }) async {
    emit(ContactUsLoading());
    try {
      if (subject.isEmpty || message.isEmpty) {
        //validation section
        if (subject.isEmpty) throw Exception("Subject cannot be empty");

        if (message.isEmpty) throw Exception("Message cannot be empty");
      } else {
        // validating password

        await CommonRepository()
            .sendEmail(subject, message, 'info@shiftcover.co.uk',staff);

        emit(ContactUsSuccess());
      }
    } catch (e) {
      emit(
        ContactUsFailure(error: e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
