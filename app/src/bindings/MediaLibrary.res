type status = {"status": string}

@module("expo-media-library")
external getPermissionsAsync: unit => Js.Promise.t<status> = "getPermissionsAsync"

@module("expo-media-library")
external requestPermissionsAsync: unit => Js.Promise.t<status> = "requestPermissionsAsync"

module Utils = {
  module Permissions = {
    let checkPermissions = async () => {
      let res = await getPermissionsAsync()
      res["status"] === "granted"
    }

    let get = async () => {
      let res = switch await checkPermissions() {
      | true => true
      | false => {
          let resPerm = await requestPermissionsAsync()
          resPerm["status"] === "granted"
        }
      }

      res
    }
  }
}
