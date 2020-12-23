import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/purchases.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class PremiumInfoCard extends StatelessWidget {

  final String assetPath;

  final String pricingLabel;

  final String pricingPeriodLabel;

  final Widget actionButton;

  final List<String> benefits;

  PremiumInfoCard ({ this.assetPath, this.pricingLabel, this.pricingPeriodLabel, this.actionButton, this.benefits });

  Widget _benefitLabel(String text) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 5
      ),
      child: Row(
        children: [
          Container(
            child: Icon(Icons.check),
            padding: EdgeInsets.only(
                right: 10
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.ubuntu
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: BrandColors.lightGreyBackgroundColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: SvgPicture.asset(this.assetPath),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                      right: 20,
                      left: 20
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(this.pricingLabel, style: TextStyle(
                                fontFamily: Fonts.ubuntu,
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),),
                            Text(this.pricingPeriodLabel, style: TextStyle(
                                fontFamily: Fonts.ubuntu,
                                fontSize: 23,
                                fontWeight: FontWeight.bold
                            ),)
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10
              ),
              child: Column(
                children: () {
                  return benefits.map((e) => _benefitLabel(e)).toList();
                }(),
              )
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: actionButton,
            )
          ],
        ),
      ),
    );
  }

}



class PremiumInfoSubPage extends NavigationDrawerContentChild {

  final IAPManager _iapManager = IAPManager();

  PremiumInfoSubPage (NavigationDrawerController controller, String key) : super(controller, key: key) {
    _iapManager.load();
  }

  Widget _selectionButton(BuildContext context, Package package, { bool isSelected }) {

    if (isSelected) {
      return ThemedButton(
        FlutterI18n.translate(context, TranslationKeys.chosen),
        icon: Icons.check,
        fontSize: 14,
        iconSize: 20,
        contentPadding: EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 18
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        buttonColor: BrandColors.secondaryButtonColor.withOpacity(0.5),
        onPressed: () {
          
        },
      );
    } else {
      return ThemedButton(
        FlutterI18n.translate(context, TranslationKeys.chose),
        fontSize: 14,
        iconSize: 20,
        contentPadding: EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 18
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        buttonColor: BrandColors.secondaryButtonColor,
        onPressed: () => _purchasePackage(context, package),
      );
    }


  }
  
  void _purchasePackage(BuildContext context, Package package) {
    _iapManager.purchasePackage(package).then((value) {
      showSnackBar(message: FlutterI18n.translate(context, TranslationKeys.successPurchase), isError: false, buildContext: context);
    }).catchError((e) {
      showSnackBar(message: FlutterI18n.translate(context, TranslationKeys.error), isError: true, buildContext: context);
    });
  }
  
  void _restorePurchases() {
    _iapManager.restore();
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      child: ScopedModel<IAPManager>(
        model: _iapManager,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget widget, IAPManager manager) {

            IAPManagerStatus status = _iapManager.state.status;

            if (status == IAPManagerStatus.loading) {
              return BackgroundBuilder.defaults.loadingDetailed(context);
            } else if (status == IAPManagerStatus.ready) {
              Package monthlyPackage = _iapManager.state.result.offerings.current.monthly;
              Package yearlyPackage = _iapManager.state.result.offerings.current.annual;



              return ListView(
                children: [
                  PremiumInfoCard(
                    pricingLabel: "€${PriceUtil.formatPrice(monthlyPackage.product.price)}",
                    pricingPeriodLabel: FlutterI18n.translate(context, TranslationKeys.pricingMonthly),
                    assetPath: AssetPaths.subPlus,
                    benefits: [
                      FlutterI18n.translate(context, TranslationKeys.benefitScans),
                      FlutterI18n.translate(context, TranslationKeys.benefitAdvancedQuizOptions),
                      FlutterI18n.translate(context, TranslationKeys.benefitCombineQuiz)
                    ],
                    actionButton: Visibility(
                      visible: _iapManager.state.result.hasPlus || !_iapManager.state.result.hasAny,
                      child: _selectionButton(
                        context,
                        monthlyPackage,
                        isSelected: _iapManager.state.result.hasPlus
                      ),
                    )
                  ),
                  PremiumInfoCard(
                    pricingLabel: "€${PriceUtil.formatPrice(yearlyPackage.product.price)}",
                    pricingPeriodLabel: FlutterI18n.translate(context, TranslationKeys.pricingAnnual),
                    benefits: [
                      FlutterI18n.translate(context, TranslationKeys.benefitUnlimitedScans),
                      FlutterI18n.translate(context, TranslationKeys.benefitAdvancedQuizOptions),
                      FlutterI18n.translate(context, TranslationKeys.benefitCombineQuiz)
                    ],
                    assetPath: AssetPaths.subPro,
                    actionButton: Visibility(
                      visible: _iapManager.state.result.hasPro || !_iapManager.state.result.hasAny,
                      child: _selectionButton(
                        context,
                        yearlyPackage,
                        isSelected: _iapManager.state.result.hasPro
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ThemedButton(
                          FlutterI18n.translate(context, TranslationKeys.restoreIAP),
                          buttonColor: Colors.transparent,
                          borderSide: BorderSide(
                            color: BrandColors.textColorLighter
                          ),
                          labelColor: BrandColors.textColorLighter,
                          onPressed: _restorePurchases,
                          borderRadius: BorderRadius.circular(12),
                        )
                      ],
                    ),
                  )
                ],
              );
            } else if (status == IAPManagerStatus.failed) {
              return BackgroundBuilder.defaults.error(context);
            } else {
              return Container();
            }

          }
        ),
      ),
    );
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.premium);
  }

}

