terraform {
  required_providers {
    atlas = {
      version = "~> 0.9.2"
      source  = "ariga/atlas"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

data "atlas_migration" "hello" {
  dir = "migrations?format=atlas"
  url = "mysql://root:pass@localhost:3307/example"
}

resource "atlas_migration" "hello" {
  dir     = "migrations?format=atlas"
  version = data.atlas_migration.hello.latest # Use latest to run all migrations
  url     = data.atlas_migration.hello.url
}
