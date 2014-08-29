#!/usrs/bin

function run_su_with_rb {

  dst="$(dirname $1)/parameters.txt"
  rm $dst
  
  for i in ${@:2}
  do
      echo $i >> $dst
  done  
  
  open --wait-apps "/Applications/SketchUp 2013/SketchUp.app"  --args -RubyStartup "$1"
  
}

