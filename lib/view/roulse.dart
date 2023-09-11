import 'package:flutter/material.dart';

class Rulse extends StatefulWidget {
  const Rulse({Key? key}) : super(key: key);

  @override
  State<Rulse> createState() => _RulseState();
}

class _RulseState extends State<Rulse> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: SingleChildScrollView(
        child:Column(
          children: [
            Text("Rulse",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 10,),
         Text(
              "1. By registering, you automatically agree to the rules of the store. "
                  "\n 2. Rules can be changed without notifying users. \n"
                  " 3. All funds on the balance are stored in BTC \n"
                  "4. If you see the cost indicated in \$, then know that it is converted at the btc rate at the time of display.\n"
                  "5. If your account is suspected of killing bank cards, the cost of bank cards will be increased for your account. \n"
                  "6. Refund of the deposit is not possible. \n"
                  "7. If you find bugs or vulnerabilities, report them via tickets. \n"
                  "7.1. If you intentionally exploit bugs or vulnerabilities for profit, your account will be permanently banned. \n"
                  "8. After cleaning the section of your purchases, the administration will not be able to return the purchased cards to you. Save cards to your devices. \n"
                  "8.1. Save cards from the purchased section. The administration will not be able to return the purchased cards to you in case of a technical failure. \n"
                  "9. The administration has the right to block an account without explanation. \n"
                  "10. If you lose access to your account, the administration will not be able to restore your data and access will be lost forever. \n"
                  "11. We are a platform where sellers can sell their cards and buyers can buy. We are not responsible for the accuracy of the information written by the seller. Create a ticket if information is inconsistent. \n"
                  "11.1. We are not responsible for the availability of funds on the purchased cards. \n"
                  "11.2. For loaded databases with the possibility of a refund, the cost of checking the card is \$1. If the card is found to be invalid, you will be refunded for the verification of the card and the cost of the card itself. \n"
                  "11.3. Refunds are possible only for invalid cards, according to the answers of our checkers. \n"
                  "11.4. After purchasing the card, you have 12 hours to open and verify the card, after the time has elapsed, you will not be able to receive a refund and the card will be opened automatically.\n"
                  " 11.5. You have 5 minutes to check the card after opening, after the time has elapsed you will not be able to request a refund for your card. \n"
                  "12. We use third-party checker APIs in our store, and we do not consider claims for its operation. \n"
                  "12.1. When the checker answers that the card is invalid, the money is automatically returned to the balance. \n"
                  "12.2. There is a restriction on checking cards after opening. You can find the limits in the FAQ. 12.3. If the card is invalid, you will not be able to view its details. \n"
                  "13. Communication with support is possible only through the ticket system. 14. CVR - the approximate percentage of valid cards in the database, is formed based on the results of checking random cards from the base."
            )
          ],
        ),
      ),
    );
  }
}
