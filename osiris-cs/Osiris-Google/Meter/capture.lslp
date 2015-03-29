string scriptName = "capture";
string secureKey="7yxpZa2Rfq/wG/LRGidWJCy8BAw=";
string myKey="B6asJOaeX/EplA2tVwWK4mmBYSM=";
string securePass = "WHGlPsm5HyMjoTSF5S0VXmKF0C8=";
string cryptPass (string str) {return llXorBase64StringsCorrect(llStringToBase64(str), llStringToBase64(securePass));}
string decryptPass (string str) {return llBase64ToString(llXorBase64StringsCorrect(str, llStringToBase64(securePass)));}
string right(string src, string divider){integer index = llSubStringIndex( src, divider );if(~index)return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);return src;}
string left(string src, string divider){integer index = llSubStringIndex( src, divider );if(~index)return llDeleteSubString( src, index, -1);return src;}
string randCheck() { return (string)llFrand(9999999999.0)+ (string)llFrand(9999999999.0);}
receiveChallenge(string msg) {
    string message=decryptPass(msg);
    string source=left(message, "|");
    string sourceKey=right(message, "||");
    securePass=right(left(message,"||"),"|"); // this line changes the initial password to the one received from security
    if (source=="security" && sourceKey==secureKey) {
        string response= scriptName + "|"+ randCheck() + "||" + myKey;
        llMessageLinked(LINK_THIS, 8001, cryptPass(response), NULL_KEY);   
    }
}

default {
    link_message(integer sender_num, integer num, string str, key id) {
        if (num==8000) {receiveChallenge(str);}
    }
}
