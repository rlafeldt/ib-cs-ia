import 'package:app_cs/widgets/contracts/contract_form.dart';
import 'package:flutter/material.dart';
import 'package:app_cs/services/responsive.dart';

class ContractInputScreen extends StatelessWidget {
  const ContractInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: const Scrollbar(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Responsive(
              mobile: MobileContractScreen(),
              desktop: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 450,
                          child: ContractForm(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileContractScreen extends StatelessWidget {
  const MobileContractScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.045),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
        ),
        // const SizedBox(height: 10),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          "Contract Information",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Flexible(
          flex: 8,
          child: ContractForm(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }
}
