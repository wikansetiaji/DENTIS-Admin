class Util{
  static Map<String,Map<String,int>> initGigiCondition(){
    Map<String,Map<String,int>> output = {};
    int i = 1;
    int j = 1;
    while (i<9){
      if (i<5){
        while (j<9){
          if (j<4){
            output.addAll({"$i$j":{"d":-1,"l":-1,"m":-1,"v":-1}});
          }
          else{
            output.addAll({"$i$j":{"d":-1,"l":-1,"o":-1,"m":-1,"v":-1}});
          }
          j++;
        }
        j=1;
      }
      else{
        while (j<6){
          if (j<4){
            output.addAll({"$i$j":{"d":-1,"l":-1,"m":-1,"v":-1}});
          }
          else{
            output.addAll({"$i$j":{"d":-1,"l":-1,"o":-1,"m":-1,"v":-1}});
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