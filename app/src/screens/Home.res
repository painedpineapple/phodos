open ReactNative

@react.component
let make = () => {
  let authorizeSession = Auth.Session.Authorize.use()
  <View style={Tw.s(`flex justify-center h-full`)}>
    <Button
      title="Authorize"
      onPress={_ => {
        open WalletAdapter

        transact(async wallet => {
          (await wallet
          ->authorize({
            cluster: #devnet,
            identity: {name: Some("phodos"), uri: None, icon: None},
          }))
          ->ignore

          (await wallet->authorizeSession)->ignore
        }, None)->ignore
      }}
    />
    <Button title="Get Photos" onPress={_ => MediaLibrary.Utils.Permissions.get()->ignore} />
    <AccountBalances />
  </View>
}
