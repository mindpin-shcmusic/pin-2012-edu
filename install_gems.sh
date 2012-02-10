case "$1" in
  ui)
    cd gems/pie-ui
    rake manifest
    rake install
    echo "OK"
  ;;
  all)
    ./install_gems.sh ui
  ;;
  *)
    echo "tip: ui"
    exit 5
  ;;
esac
exit 0
