import 'package:flutter/material.dart';

class NameAndAboutTextFields extends StatelessWidget {
  final bool isEditing;

  final TextEditingController nameController;
  final TextEditingController aboutController;

  NameAndAboutTextFields({
    Key? key,
    this.isEditing = false,
    required this.nameController,
    required this.aboutController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 200.0,
              child: TextFormField(
                controller: nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Name can\'t be empty' : null,
                // onSaved: nameOnSaved,
                //  onSaved: (value) => name = value,
                // controller: _nameController,
                // initialValue: nameInitialValue,
                textAlign: TextAlign.center,
                enabled: isEditing,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: !isEditing ? InputBorder.none : null,
                  // focusedBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  // disabledBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: isEditing ? 20.0 : 0.0),
            TextFormField(
              controller: aboutController,
              //  initialValue: aboutInitialValue ?? '',
              validator: (value) =>
                  value!.isEmpty ? 'About can\'t be empty' : null,
              //onSaved: aboutOnSaved,
              //  onSaved: (value) => about = value,
              //controller: _aboutController,
              enabled: isEditing,
              maxLength: 100,
              minLines: 1,
              maxLines: 2,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Tell us something about you',
                disabledBorder: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// : Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 14.0),
                //     child: Center(
                //       child: Column(
                //         children: [
                //           SizedBox(
                //             width: 200.0,
                //             child: TextFormField(
                //               validator: (value) => value!.isEmpty
                //                   ? 'About can\'t be empty'
                //                   : null,
                //               onSaved: (value) => _name = value,
                //               // controller: _nameController,
                //               initialValue: state.appUser.name,
                //               textAlign: TextAlign.center,
                //               enabled: _editting,
                //               style: TextStyle(
                //                 fontSize: 17.0,
                //                 fontWeight: FontWeight.w600,
                //                 letterSpacing: 1.0,
                //               ),
                //               decoration: InputDecoration(
                //                 hintText: 'Enter your name',
                //                 border:
                //                     !_editting ? InputBorder.none : null,
                //                 // focusedBorder: InputBorder.none,
                //                 // enabledBorder: InputBorder.none,
                //                 // errorBorder: InputBorder.none,
                //                 // disabledBorder: InputBorder.none,
                //               ),
                //             ),
                //           ),
                //           SizedBox(height: _editting ? 20.0 : 0.0),
                //           TextFormField(
                //             initialValue: state.appUser.about ?? '',
                //             validator: (value) => value!.isEmpty
                //                 ? 'About can\'t be empty'
                //                 : null,
                //             onSaved: (value) => _about = value,
                //             //controller: _aboutController,
                //             enabled: _editting,
                //             maxLength: 100,
                //             minLines: 1,
                //             maxLines: 2,
                //             textAlign: TextAlign.center,
                //             decoration: InputDecoration(
                //               hintText: 'Tell us something about you',
                //               disabledBorder: InputBorder.none,
                //               focusedBorder: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(3.0),
                //                 borderSide: BorderSide(color: Colors.green),
                //               ),
                //               enabledBorder: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(3.0),
                //                 borderSide: BorderSide(color: Colors.green),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),