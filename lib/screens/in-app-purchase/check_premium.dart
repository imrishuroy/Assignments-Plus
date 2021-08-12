import 'package:assignments/blocs/auth/auth_bloc.dart';
import 'package:assignments/screens/in-app-purchase/in_app_puchase_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckPremium extends StatelessWidget {
  CheckPremium({Key? key}) : super(key: key);

  final _firebstore = FirebaseFirestore.instance;

  bool _isAvailable = false;

  @override
  Widget build(BuildContext context) {
    final _authBloc = context.read<AuthBloc>();
    print(_authBloc.state.user?.uid);

    final _userID = _authBloc.state.user?.uid;

    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firebstore.collection('purchases').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.size,
            itemBuilder: (context, index) {
              final data = snapshot.data?.docs;

              data?.forEach((element) {
                final pruchaseData = element.data() as Map<String, dynamic>;
                if (_userID == pruchaseData['userId']) {
                  _isAvailable = true;
                }
              });

              if (_isAvailable) {
                return Text(
                  'Premium User',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                );
              } else {
                return InAppPurchaseButton();
              }
            },
          );
        },
      ),
    );
  }
}
