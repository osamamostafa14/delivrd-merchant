import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final int? maxLines;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowPrefixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool? isSearch;
  final Function? onSubmit;
  final bool? isEnabled;
  final TextCapitalization? capitalization;
  final bool? dontEdit;
  final int? maxLength;
  final double? height;

  CustomTextField(
      {this.hintText = 'Write something...',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.onSuffixTap,
        this.fillColor,
        this.onSubmit,
        this.onChanged,
        this.capitalization = TextCapitalization.none,
        this.isCountryPicker = false,
        this.isShowBorder = false,
        this.isShowSuffixIcon = false,
        this.isShowPrefixIcon = false,
        this.onTap,
        this.isIcon = false,
        this.isPassword = false,
        this.suffixIconUrl,
        this.prefixIconUrl,
        this.isSearch = false,
        this.dontEdit = false,
        this.maxLength,
        this.height,
      });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: widget.maxLength ?? 250,
      readOnly: this.widget.dontEdit!,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.headline2!.copyWith(
          color: Colors.black87,
          fontSize: 14),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization!,
      enabled: widget.isEnabled,
      autofocus: false,
      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword! ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
      ]
          : null,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.symmetric(vertical: widget.height !=null? 10:15, horizontal: 22),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              width: 1.0,
            )),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).backgroundColor, // Set the desired color when focused
            width: 1.0,
          ),
        ),

        isDense: true,
        hintText: widget.hintText,
        fillColor: widget.fillColor != null
            ? widget.fillColor
            : Colors.white,
        hintStyle: Theme.of(context).textTheme.headline2!.copyWith(
            fontSize: 15,
            color: Colors.black45),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon!
            ? Padding(
          padding: const EdgeInsets.only(
              left: 12,
              right: 15),
          child: Image.asset(widget.prefixIconUrl!, height: 24,
              color: Theme.of(context).textTheme.headline2!.color),
        )
            : SizedBox.shrink(),
        prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 24),

        suffixIcon: widget.isShowSuffixIcon!
            ? widget.isPassword!
            ? IconButton(
            icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color:  Colors.black45),
            onPressed: _toggle)
            : widget.isIcon!
            ?
        Image.asset(
          widget.suffixIconUrl!,
          width: 10,
          height: 10,
          color: Theme.of(context).textTheme.headline2!.color,
        )
            : null
            : null,
      ),
      onTap: widget.onTap,
      onSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null
          ? widget.onSubmit!(text)
          : null,
      onChanged: widget.onChanged,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
