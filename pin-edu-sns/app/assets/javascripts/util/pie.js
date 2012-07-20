pie = {};

pie.load = function(func){
  jQuery(function(){
    try{
      func();
    }catch(e){
      console.log("错误: " + e)
    }
  });
};

// firefox/chrome/safari控制台方法代理
pie.log = function(){
  var arr = [];
  for(i=0;i<arguments.length;i++){
    arr.push('arguments['+i+']')
  }
  eval('try{console.log('+arr.join(',')+')}catch(e){}')
}