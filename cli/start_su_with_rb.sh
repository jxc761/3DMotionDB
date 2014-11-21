#!/usrs/bin

function run_su_with_rb {

  dst="$(dirname $1)/parameters.txt"
  rm $dst
  
  for i in ${@:2}
  do
      echo $i >> $dst
  done  
  
  # open --wait-apps "/Applications/SketchUp 2013/SketchUp.app"  --args -RubyStartup "$1"
  SU=`find /Applications -maxdepth 2 -iname Sketchup.app | head -1`
  if [ "$SU" == "" ];then
     echo "Cannot find Sketchup. Please install Sketchup first..."
     exit
  fi
  
  open --wait-apps "$SU"  --args -RubyStartup "$1"
}
