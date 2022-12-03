import 'package:assignments/models/contact_us.dart';
import 'package:assignments/models/failure_model.dart';
import 'package:assignments/repositories/services/firebase_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contactus_state.dart';

class ContactusCubit extends Cubit<ContactusState> {
  final FirebaseServices _firebaseServices;
  ContactusCubit({required FirebaseServices firebaseServices})
      : _firebaseServices = firebaseServices,
        super(ContactusState.initial());

  void nameChanged(String name) async {
    emit(state.copyWith(name: name, status: ContactUsStatus.initial));
  }

  void emailChanged(String email) async {
    emit(state.copyWith(email: email, status: ContactUsStatus.initial));
  }

  void messageChanged(String message) async {
    emit(state.copyWith(message: message, status: ContactUsStatus.initial));
  }

  void submit() async {
    if (state.status == ContactUsStatus.submitting) return;
    try {
      emit(state.copyWith(status: ContactUsStatus.submitting));
      await _firebaseServices.sendContactUsInformation(ContactUs(
        name: state.name,
        email: state.email,
        message: state.message,
      ));
      emit(state.copyWith(status: ContactUsStatus.succuss));
    } on Failure catch (error) {
      emit(state.copyWith(
        status: ContactUsStatus.error,
        failure: Failure(message: error.toString()),
      ));
    }
  }
}
