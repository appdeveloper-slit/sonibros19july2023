import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sb/values/colors.dart';
import 'package:sb/values/dimens.dart';
import 'package:sb/values/strings.dart';
import 'package:sb/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';
import 'myaddress.dart';

class AddAdress extends StatefulWidget {
  String? stype;
  String? addressid;

  AddAdress({Key? key, this.stype, this.addressid}) : super(key: key);

  @override
  State<AddAdress> createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdress> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController landmarkCtrl = TextEditingController();
  TextEditingController pincodeCtrl = TextEditingController();
  String? sUserid;
  List<String> countryList = ['India', 'Usa', 'England'];
  String? sCountry;
  bool isCountry = false;

  String? sCountrylabel;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id') ?? "";
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getAdress();
      }
    });
  }

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            STM().replacePage(ctx, MyAddress());
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        title: Text(
          'Add Address',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Dim().d20,
                ),
                TextFormField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                        hintText: 'Enter Name',
                        hintStyle: Sty().mediumText.copyWith(
                              color: Clr().hintColor,
                            ),
                      ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                TextFormField(
                  controller: mobileCtrl,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'\d')),
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                        counterText: '',
                        hintText: 'Enter Mobile Number',
                        hintStyle: Sty().mediumText.copyWith(
                              color: Clr().hintColor,
                            ),
                      ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'([5-9]\d{9})').hasMatch(value)) {
                      return Str().invalidMobile;
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                TextFormField(
                  controller: addressCtrl,
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                        hintText: 'Enter Address',
                        hintStyle: Sty().mediumText.copyWith(
                              color: Clr().hintColor,
                            ),
                      ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                TextFormField(
                  controller: landmarkCtrl,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                        hintText: 'Enter Landmark',
                        hintStyle: Sty().mediumText.copyWith(
                              color: Clr().hintColor,
                            ),
                      ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Clr().white,
                    border: isCountry
                        ? Border.all(
                            color: Clr().errorRed,
                          )
                        : Border.all(
                            color: Clr().lightGrey,
                          ),
                    borderRadius: BorderRadius.circular(
                      Dim().d4,
                    ),
                  ),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        hint: Text(
                          sCountry ?? 'Select Country',
                          style: Sty().mediumText.copyWith(
                                color: Clr().hintColor,
                              ),
                        ),
                        value: sCountry,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: Sty().mediumText,
                        onChanged: (String? value) {
                          setState(() {
                            sCountry = value!;
                            isCountry = false;
                          });
                        },
                        items: countryList.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Sty().mediumText,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                TextFormField(
                  controller: pincodeCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (value) {
                    if (value!.isEmpty || value.length != 6) {
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                        counterText: '',
                        hintText: 'Enter Pincode',
                        hintStyle: Sty().mediumText.copyWith(
                              color: Clr().hintColor,
                            ),
                      ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  children: [
                    widget.stype == 'update'
                        ? Expanded(
                            child: InkWell(
                            onTap: () {
                              setState(() {
                                isCountry = sCountry == null ? true : false;
                              });
                              if (formKey.currentState!.validate() &&
                                  !isCountry) {
                                STM()
                                    .checkInternet(context, widget)
                                    .then((value) {
                                  if (value) {
                                    updateAdress();
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: Dim().d56,
                              decoration: BoxDecoration(
                                color: Color(0xff2C2C2C),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d16)),
                                border: Border.all(color: Clr().lightGrey),
                              ),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().white),
                                ),
                              ),
                            ),
                          ))
                        : Expanded(
                            child: InkWell(
                            onTap: () {
                              setState(() {
                                isCountry = sCountry == null ? true : false;
                              });
                              if (formKey.currentState!.validate() &&
                                  !isCountry) {
                                STM()
                                    .checkInternet(context, widget)
                                    .then((value) {
                                  if (value) {
                                    addAdress();
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: Dim().d56,
                              decoration: BoxDecoration(
                                color: Color(0xff2C2C2C),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d16)),
                                border: Border.all(color: Clr().lightGrey),
                              ),
                              child: Center(
                                child: Text(
                                  'Add',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().white),
                                ),
                              ),
                            ),
                          )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addAdress() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'name': nameCtrl.text,
      'mobile': mobileCtrl.text,
      'address': addressCtrl.text,
      'landmark': landmarkCtrl.text,
      'country': sCountry,
      'pincode': pincodeCtrl.text,
    });
    var result = await STM().post(ctx, Str().processing, 'add_address', body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      setState(() {
        STM().successDialog(ctx, message, MyAddress());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void updateAdress() async {
    FormData body = FormData.fromMap({
      'id': widget.addressid,
      'name': nameCtrl.text,
      'mobile': mobileCtrl.text,
      'address': addressCtrl.text,
      'landmark': landmarkCtrl.text,
      'country': sCountry,
      'pincode': pincodeCtrl.text,
    });
    var result = await STM().post(ctx, Str().updating, 'update_address', body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (error == false) {
      setState(() {
        STM().successDialog(ctx, message, MyAddress());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getAdress() async {
    FormData body = FormData.fromMap({
      'id': widget.addressid,
    });
    var result = await STM().post(ctx, Str().updating, 'get_address', body);
    if (!mounted) return;
    setState(() {
      nameCtrl = TextEditingController(text: result['name'].toString());
      mobileCtrl = TextEditingController(text: result['mobile'].toString());
      addressCtrl = TextEditingController(text: result['address'].toString());
      landmarkCtrl = TextEditingController(text: result['landmark'].toString());
      result['country'] == null
          ? sCountrylabel = result['country'].toString()
          : sCountry = result['country'].toString();
      pincodeCtrl = TextEditingController(text: result['pincode'].toString());
    });
  }
}
