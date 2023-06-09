open ReactNative
open Belt
open Helpers

module Balance = {
  exception BalanceError(string)
  @react.component
  let make = (~account: Auth.account) => {
    let balance = Connection.Balance.use(account)

    <Text>
      {switch balance {
      | {isLoading: true} => "Balance Loading"->str
      | {data: Some(balance), isLoading: false, isError: false} =>
        <Text>
          {"Balance: "->str}
          {balance->Js.Float.toString->str}
          {" SOL"->str}
        </Text>
      | {isError: true, error} =>
        switch error->Js.Nullable.toOption {
        | None => "Balance not found"->str
        | Some(error) => error->BalanceError->raise
        }
      | _ => "Balance not found"->str
      }}
    </Text>
  }
}

@react.component
let make = () => {
  let (session, _) = Auth.Session.use()

  {
    switch session {
    | Some(session) =>
      <View>
        {session.accounts
        ->Array.map(account => <Balance key={account.publicKey->Web3.PublicKey.toString} account />)
        ->React.array}
      </View>
    | _ => React.null
    }
  }
}
