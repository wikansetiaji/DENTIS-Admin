class Util{
  static Map<String,Map<String,int>> initGigiCondition(){
    Map<String,Map<String,int>> output = {};
    int i = 1;
    int j = 1;
    while (i<9){
      if (i<5){
        while (j<9){
          if (j<4){
            output.addAll({"$i$j":{"d":0,"l":0,"m":0,"v":0}});
          }
          else{
            output.addAll({"$i$j":{"d":0,"l":0,"o":0,"m":0,"v":0}});
          }
          j++;
        }
        j=1;
      }
      else{
        while (j<6){
          if (j<4){
            output.addAll({"$i$j":{"d":0,"l":0,"m":0,"v":0}});
          }
          else{
            output.addAll({"$i$j":{"d":0,"l":0,"o":0,"m":0,"v":0}});
          }
          j++;
        }
        j=1;
      }
      i++;
    }
    return output;
  }
}