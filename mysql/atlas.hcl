# The "local" environment represents our local testings.
env "local" {
  url = "mysql://root:pass@:3306/example"
  migration {
    dir = "atlas://mysqlapp"
  }
}