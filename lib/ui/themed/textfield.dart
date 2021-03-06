import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';

class Validators {

  final BuildContext buildContext;

  Validators (this.buildContext);

  String notEmptyValidator(String value) {
    if (value != null && value.isNotEmpty)
      return null;
    return FlutterI18n.translate(this.buildContext, TranslationKeys.emptyTextError);
  }

}

class ThemedTextField extends StatelessWidget {

  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController textEditingController;
  final Function(String) validator;
  final Function(String) onChanged;
  final Function onEditingComplete;

  final EdgeInsets contentPadding;
  final Color errorColor;
  final Color focusedColor;
  final Color borderColor;
  final Color fillColor;
  final Color labelColor;
  final double borderRadius;
  final double borderWidth;
  final Widget suffixIcon;
  final BorderSide customBorderSide;
  final EdgeInsets margin;


  ThemedTextField ({ this.labelText, this.hintText, this.labelColor, this.suffixIcon, this.borderWidth, this.obscureText = false, this.contentPadding, this.textEditingController, this.margin, this.validator, this.errorColor, this.focusedColor, this.fillColor, this.borderColor, this.onChanged, this.borderRadius = 20, this.customBorderSide, this.onEditingComplete });

  InputBorder inputBorder({ @required Color borderColor }) {
    return OutlineInputBorder(
      borderSide: customBorderSide ?? BorderSide(
          color: borderColor,
          width: borderWidth ?? 2
      ),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );
  }

  Widget textField() {
    return Container(
      child: TextFormField(
        obscureText: obscureText,
        controller: textEditingController,
        onEditingComplete: onEditingComplete,
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(
            fontFamily: Fonts.ubuntu,
            fontWeight: FontWeight.w600,
            color: BrandColors.textColorLighter,
            fontSize: 14
        ),
        decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: fillColor ?? Color.fromRGBO(255, 255, 255, 0.7),
            contentPadding: contentPadding ?? EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20
            ),
            suffixIcon: suffixIcon,
            border: inputBorder(borderColor: borderColor ?? BrandColors.inputBorderColor),
            enabledBorder: inputBorder(borderColor: borderColor ?? BrandColors.inputBorderColor),
            focusedBorder: inputBorder(borderColor: focusedColor ?? BrandColors.inputFocusedColor),
            errorBorder: inputBorder(borderColor: errorColor ?? BrandColors.inputErrorColor)
        ),
      ),
      margin: margin ?? EdgeInsets.symmetric(
          vertical: 12
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.labelText == null) {
      return textField();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            labelText,
            style: TextStyle(
                fontFamily: Fonts.ubuntu,
                fontWeight: FontWeight.w600,
                color: labelColor ?? Colors.white,
                fontSize: 15
            ),
          ),
          textField()
        ],
      );
    }

  }

}


class ThemedSearchTextField extends StatelessWidget {

  final String hint;
  final TextEditingController textEditingController;
  final Function(String) onChanged;
  final Function(String) onSubmitted;

  ThemedSearchTextField ({ this.hint, this.textEditingController, this.onChanged, this.onSubmitted });

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: BrandColors.lightGreyBackgroundColor),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: TextStyle(
          fontSize: 14,
          fontFamily: Fonts.ubuntu
      ),
      onSubmitted: this.onSubmitted,
      onChanged: this.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: BrandColors.lightGreyBackgroundColor,
        prefixIcon: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            height: 40,
            width: 40,
            child: Center(
              child: Icon(
                Icons.search,
                size: 24,
                color: BrandColors.textColorLighter,
              ),
            ),
          ),
        ),
        contentPadding: EdgeInsets.only(left: 14.0, bottom: 12.0, top: 0.0),
        focusedBorder: inputBorder(),
        hintText: hint,
        enabledBorder: inputBorder(),
      ),
    );
  }

}