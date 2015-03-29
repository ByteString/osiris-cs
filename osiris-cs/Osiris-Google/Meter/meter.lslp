string scriptName = "meter";
string secureKey = "7yxpZa2Rfq/wG/LRGidWJCy8BAw=";
string myKey = "dJRvOIRt+GK14qEIc4vaK48UYGc=";
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

integer debug = 0;
string version = "0.85";
integer health = 100;
integer maxhealth = 100;
integer stamina = 100;
integer maxstamina = 100;
integer special;
string SP_NAME;
string race;
string class;
string class1;
string class2;
string level;
integer level1;
integer level2;
float deathtimer;
integer healwhiledead;
integer killamt;
integer movewhiledead;
float woundedtimer;
string dtext;
vector color = <1.0,1.0,1.0>;
string gmLevel;
integer gmStatus;
integer status;
                // 1 = noncombative; 
                // 2 = observer/setup incomplete, 
                // 3 = out of character
                // 4 = captured
                // 5 = dead
                // 6 = loading
                // 7 = wounded
                // 99 = checking security
string title = "";

// SET PARAMETERS FOR METER DISPLAY AND OPERATION ********************
setParam(string parameter,string value){
    if ((parameter == "DEATHTIMER")) {
        (deathtimer = ((float)value));
    }
    else  if ((parameter == "HEALWHILEDEAD")) {
        (healwhiledead = ((integer)value));
    }
    else  if ((parameter == "KILLAMT")) {
        (killamt = ((integer)value));
    }
    else  if ((parameter == "MOVEWHILEDEAD")) {
        (movewhiledead = ((integer)value));
    }
    else  if ((parameter == "WOUNDEDTIMER")) {
        (woundedtimer = ((float)value));
    }
    else  if ((parameter == "DTEXT")) {
        (dtext = value);
    }
}

// SET STATUS
setStatus(integer num){
    if ((debug == 1)) {
        llOwnerSay("METER: Receiving status update");
    }
    (status = num);
    updateHud("0",0);
}
// SET CHARACTER STUFF
setRace(string n){
    (race = n);
}
setSpecial(float num){
    (special = llCeil(num));
    updateHud("health",health);
}
setStam(integer amount){
    if (((stamina < 100) | (amount < 0))) {
        (stamina = (stamina + amount));
        if ((stamina > 100)) {
            (stamina = 100);
        }
        if ((stamina < 0)) {
            (stamina = 0);
        }
        llMessageLinked(LINK_THIS,9985,((string)stamina),NULL_KEY);
        updateHud("health",health);
        sendToHud(("STAMINA|" + ((string)stamina)));
    }
}
setSP(string name){
    (SP_NAME = name);
}
setClass1(string name){
    (class1 = name);
    (class = class1);
}
setClass2(string name){
    (class2 = name);
    (class = ((class1 + "/") + class2));
}
setLevel1(integer num){
    (level1 = num);
    (level = ((string)level1));
}
setLevel2(integer num){
    (level2 = num);
    (level = ((((string)level1) + "/") + ((string)level2)));
}

// SET GM LEVEL 
setGM(integer num){
    if ((num == 10)) {
        (gmStatus = num);
        (gmLevel = "(Lead GM)\n");
    }
    else  if ((num == 9)) {
        (gmStatus = num);
        (gmLevel = "(Sr. GM)\n");
    }
    else  if ((num == 5)) {
        (gmStatus = num);
        (gmLevel = "(GM)\n");
    }
    else  if ((num == 4)) {
        (gmStatus = num);
        (gmLevel = "(Roleplay Staff)\n");
    }
    else  {
        (gmStatus = num);
        (gmLevel = "");
    }
    updateHud("update",gmStatus);
}
// SET HUD STATUS
setOff(){
    if ((status == 2)) {
        llOwnerSay("You must complete your character setup before you can leave observer mode.  Log in at www.rpcombat.com to complete character setup.");
    }
    else  {
        setStatus(1);
        updateHud("update",0);
    }
}
SetMaxHealth(integer amount){
    (maxhealth = amount);
}
// UPDATE HOVERTEXT FOR METER
updateHud(string attr,integer num){
    integer DisHealth = llCeil(((((float)health) / ((float)maxhealth)) * 100));
    integer DisStam = llCeil(((((float)stamina) / ((float)maxstamina)) * 100));
    string lversion;
    if ((title != "")) {
        (lversion = ((version + "\n") + title));
    }
    else  if ((title == "")) {
        (lversion = version);
    }
    if ((status == 0)) {
        if ((attr == "health")) {
            (health = num);
            llSetText(((((((((((((((((((gmLevel + "RPCS v") + lversion) + "\n") + race) + " ") + class) + " Level: ") + level) + "\n") + "Health: ") + ((string)DisHealth)) + "% Stamina: ") + ((string)DisStam)) + "%  ") + SP_NAME) + ": ") + ((string)special)) + "%"),color,1);
        }
        else  if ((attr == "update")) {
            (health = num);
            llSetText(((((((((((((((((((gmLevel + "RPCS v") + lversion) + "\n") + race) + " ") + class) + " Level: ") + level) + "\n") + "Health: ") + ((string)DisHealth)) + "% Stamina: ") + ((string)DisStam)) + "% ") + SP_NAME) + ": ") + ((string)special)) + "%"),color,1);
        }
        else  if ((attr == "loading")) {
            llSetText((("RPCS v" + version) + "\n(loading)"),<1.0,1.0,1.0>,1);
        }
    }
    else  if ((status == 1)) {
        if ((attr == "update")) {
            llSetText((((gmLevel + "RPCS v") + lversion) + "\n(Noncombative)"),color,1);
        }
        else  if ((attr == "loading")) {
            llSetText((("RPCS v" + version) + "\n(loading)"),<1.0,1.0,1.0>,1);
        }
    }
    else  if ((status == 2)) {
        llSetText((((gmLevel + "RPCS v") + version) + "\n(Observer/No Char)"),<0.0,1.0,1.0>,1);
    }
    else  if ((status == 5)) {
        llSetText((((((gmLevel + "RPCS v") + lversion) + "\n(NonCombative - ") + dtext) + ")"),<1.0,0.0,0.0>,1);
    }
    else  if ((status == 6)) {
        llSetText((("RPCS v" + version) + "\n(loading)"),<1.0,1.0,1.0>,1);
    }
    else  if ((status == 7)) {
        llSetText((((gmLevel + "RPCS v") + lversion) + "\n(NonCombative - Wounded)"),color,1);
    }
}
sendToHud(string str){
    llMessageLinked(LINK_THIS,7000,str,NULL_KEY);
}
setColor(string msg){
    if ((msg == "red")) (color = <1.0,0.0,0.0>);
    else  if ((msg == "green")) (color = <0.0,1.0,0.0>);
    else  if ((msg == "blue")) (color = <0.0,0.0,1.0>);
    else  if ((msg == "grey")) (color = <0.5,0.5,0.5>);
    else  if ((msg == "white")) (color = <1.0,1.0,1.0>);
    else  if ((msg == "yellow")) (color = <1.0,1.0,0.0>);
    else  if ((msg == "cyan")) (color = <0.0,1.0,1.0>);
    else  if ((msg == "magenta")) (color = <1.0,0.0,1.0>);
    else  if ((msg == "pink")) (color = <1.0,0.4,0.8>);
    else  if ((msg == "aqua")) (color = <0.0,0.6,0.6>);
    else  if ((msg == "purple")) (color = <0.4,0.0,0.8>);
    else  {
        llOwnerSay("Please select one of the following colors: red, green, blue, grey, white, yellow, cyan, magenta, pink, aqua, purple");
    }
    updateHud("update",health);
}
setTitle(string s){
    (title = s);
    if ((title == "title")) (title = "");
    updateHud("update",health);
}

default {

    state_entry() {
        llSetText("Checking RPCS",<1.0,1.0,1.0>,1.0);
    }

     link_message(integer sender_num,integer num,string str,key id) {
        if ((num == 7)) {
            setStatus(((integer)str));
            if ((str == "6")) {
                state load;
            }
        }
        else  if ((num == 8000)) {
            receiveChallenge(str);
        }
        else  if ((num == 9990)) {
            SetMaxHealth(((integer)str));
        }
        else  if ((num == 9970)) {
            setSpecial(((float)str));
        }
        else  if ((num == 9931)) {
            setStam(((integer)str));
        }
        else  if ((num == 1)) {
            string param = left(str,"|");
            if ((param == "GMLEVEL")) setGM(((integer)right(str,"|")));
            else  if ((param == "RNAME")) setRace(right(str,"|"));
            else  if ((param == "CNAME1")) setClass1(right(str,"|"));
            else  if ((param == "CNAME2")) setClass2(right(str,"|"));
            else  if ((param == "LVL1")) setLevel1(((integer)right(str,"|")));
            else  if ((param == "LVL2")) setLevel2(((integer)right(str,"|")));
            else  if ((param == "SP_NAME")) setSP(right(str,"|"));
            else  if ((param == "DEATHTIMER")) setParam(left(str,"|"),right(str,"|"));
            else  if ((param == "HEALWHILEDEAD")) setParam(left(str,"|"),right(str,"|"));
            else  if ((param == "KILLAMT")) setParam(left(str,"|"),right(str,"|"));
            else  if ((param == "MOVEWHILEDEAD")) setParam(left(str,"|"),right(str,"|"));
            else  if ((param == "WOUNDEDTIMER")) setParam(left(str,"|"),right(str,"|"));
            else  if ((param == "DTEXT")) setParam(left(str,"|"),right(str,"|"));
        }
    }

    changed(integer f_Changed) {
        if ((f_Changed & CHANGED_OWNER)) llResetScript();
    }
}
state load {

    state_entry() {
        updateHud("loading",1);
    }

    link_message(integer sender_num,integer num,string str,key id) {
        if ((num == 7)) {
            setStatus(((integer)str));
            if ((str == "99")) {
                state default;
            }
            else  if ((str == "6")) {
                updateHud("loading",1);
            }
            else  if ((str == "2")) state nochar;
        }
        else  if ((num == 9990)) {
            SetMaxHealth(((integer)str));
        }
        else  if ((num == 9970)) {
            setSpecial(((float)str));
        }
        else  if ((num == 9931)) {
            setStam(((integer)str));
        }
        else  if ((num == 8000)) {
            receiveChallenge(str);
        }
        else  if ((num == 6500)) {
            setColor(str);
        }
        else  if ((num == 6501)) {
            setTitle(str);
        }
        else  if ((num == 9998)) {
            (health = ((integer)str));
        }
        else  if ((num == 1)) {
            string loadparam = left(str,"|");
            if ((str == "loading")) {
                updateHud("loading",0);
                setStatus(6);
            }
            else  if ((loadparam == "GMLEVEL")) setGM(((integer)right(str,"|")));
            else  if ((loadparam == "RNAME")) setRace(right(str,"|"));
            else  if ((loadparam == "CNAME1")) setClass1(right(str,"|"));
            else  if ((loadparam == "CNAME2")) setClass2(right(str,"|"));
            else  if ((loadparam == "LVL1")) setLevel1(((integer)right(str,"|")));
            else  if ((loadparam == "LVL2")) setLevel2(((integer)right(str,"|")));
            else  if ((loadparam == "SP_NAME")) setSP(right(str,"|"));
            else  if ((loadparam == "DEATHTIMER")) setParam(left(str,"|"),right(str,"|"));
            else  if ((loadparam == "HEALWHILEDEAD")) setParam(left(str,"|"),right(str,"|"));
            else  if ((loadparam == "KILLAMT")) setParam(left(str,"|"),right(str,"|"));
            else  if ((loadparam == "MOVEWHILEDEAD")) setParam(left(str,"|"),right(str,"|"));
            else  if ((loadparam == "WOUNDEDTIMER")) setParam(left(str,"|"),right(str,"|"));
            else  if ((loadparam == "DTEXT")) setParam(left(str,"|"),right(str,"|"));
            else  if ((loadparam == "LOADCOMPLETE")) {
                state running;
            }
        }
    }
}
state running {

    state_entry() {
        setStatus(0);
        llSetTimerEvent(10.0);
    }

    link_message(integer sender_num,integer num,string str,key id) {
        if ((num == 7)) {
            setStatus(((integer)str));
            if ((str == "99")) {
                state default;
            }
            else  if ((str == "0")) {
                setStatus(0);
            }
            else  if ((str == "1")) {
                setOff();
            }
        }
        else  if ((num == 6500)) {
            setColor(str);
        }
        else  if ((num == 6501)) {
            setTitle(str);
        }
        else  if ((num == 9998)) {
            (health = ((integer)str));
            updateHud("health",health);
        }
        else  if ((num == 9990)) {
            SetMaxHealth(((integer)str));
        }
        else  if ((num == 9970)) {
            setSpecial(((float)str));
        }
        else  if ((num == 9931)) {
            setStam(((integer)str));
        }
        else  if ((num == 9981)) {
            setStam(((integer)str));
        }
        else  if ((num == 8000)) {
            receiveChallenge(str);
        }
        else  if ((num == 1)) {
            if ((str == "doreset")) state default;
        }
    }

    timer() {
        llMessageLinked(LINK_THIS,9985,((string)stamina),NULL_KEY);
        sendToHud(("STAMINA|" + ((string)stamina)));
        llSetTimerEvent(0.0);
    }
}
state nochar {

    state_entry() {
        setStatus(2);
    }

    link_message(integer sender_num,integer num,string str,key id) {
        if ((num == 1)) {
            if ((str == "doreset")) state default;
        }
        else  if ((num == 8000)) {
            receiveChallenge(str);
        }
    }
}
