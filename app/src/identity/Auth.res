open Belt

let cluster = #devnet

exception AddressNotAvailable(string)

type account = {
  address: WalletAdapter.base64EncodedAddress,
  @optional
  label: option<string>,
  publicKey: Web3.PublicKey.t,
}

type authorization = {
  accounts: array<account>,
  authToken: option<WalletAdapter.authToken>,
  selectedAccount: option<account>,
}

let appIdentity: WalletAdapter.appIdentity = {
  name: Some("phodos"),
  icon: None,
  uri: None,
}

let getPublicKeyFromAddress = (address: WalletAdapter.base64EncodedAddress): Web3.PublicKey.t => {
  open Web3.PublicKey
  make(PublicKeyInitData(JsBase64.toUint8ArrayWithArrInt(address)))
}

let getAccountFromAuthorizedAccount = (account: WalletAdapter.account): account => {
  {
    label: account.label,
    address: account.address,
    publicKey: getPublicKeyFromAddress(account.address),
  }
}

let getAuthorizationFromAuthorizationResult = (
  authorizationResult: WalletAdapter.authorizationResult,
  previouslySelectedAccount: option<account>,
): authorization => {
  let prevSelectedAccount = authorizationResult.accounts->Array.some(({address}) =>
    switch previouslySelectedAccount {
    | Some({address: prevAddress}) => prevAddress === address
    | None => false
    }
  )

  let accounts = authorizationResult.accounts->Array.map(getAccountFromAuthorizedAccount)
  let authToken = authorizationResult.auth_token->Some
  let firstAccount = authorizationResult.accounts->Array.get(0)

  switch (prevSelectedAccount, firstAccount) {
  | (true, Some(firstAccount)) =>
    let selectedAccount = getAccountFromAuthorizedAccount(firstAccount)->Some

    {
      accounts,
      authToken,
      selectedAccount,
    }
  | _ => {
      selectedAccount: previouslySelectedAccount,
      accounts,
      authToken,
    }
  }
}

module Accounts = {
  let atom: Jotai.Atom.t<array<account>, _, _> = Jotai.Atom.make([])
  let use = () => Jotai.Atom.use(atom)

  module Selected = {
    let atom: Jotai.Atom.t<option<account>, _, _> = Jotai.Atom.make(None)
    let use = () => Jotai.Atom.use(atom)
  }
}

module Session = {
  let atom: Jotai.Atom.t<option<authorization>, _, _> = Jotai.Atom.make(None)
  let use = () => Jotai.Atom.use(atom)

  module Authorize = {
    let use = () => {
      let (session, setSession) = use()

      React.useCallback2(async (wallet: WalletAdapter.wallet) => {
        let result = await (
          switch session {
          | Some({authToken: Some(auth_token)}) =>
            wallet.reauthorize({
              auth_token,
              identity: appIdentity,
            })
          | _ =>
            wallet.authorize({
              cluster,
              identity: appIdentity,
            })
          }
        )

        let nextAuth = getAuthorizationFromAuthorizationResult(
          result,
          session->Option.flatMap(i => i.selectedAccount),
        )

        setSession(_ => nextAuth->Some)
        nextAuth.selectedAccount
      }, (session, setSession))
    }
  }

  module Deauthorize = {
    type params = {deauthorize: WalletAdapter.deauthorizeApi => Js.Promise.t<unit>}

    let use = () => {
      let (session, setSession) = use()

      React.useCallback2(async (wallet: params) => {
        switch session {
        | None
        | Some({authToken: None}) => ()
        | Some({authToken: Some(auth_token)}) => {
            await wallet.deauthorize({auth_token: auth_token})
            setSession(_ => None)
          }
        }
      }, (session, setSession))
    }
  }

  module Change = {
    let use = () => {
      let (session, setSession) = use()

      React.useCallback2((nextSelectedAccount: account) => {
        setSession(currentSession => {
          let newSession = switch currentSession {
          | Some(currentSession) =>
            switch currentSession.accounts->Array.some(
              ({address}) => address === nextSelectedAccount.address,
            ) {
            | true =>
              {
                ...currentSession,
                selectedAccount: nextSelectedAccount->Some,
              }->Some
            | false => nextSelectedAccount.address->AddressNotAvailable->raise
            }
          | _ => nextSelectedAccount.address->AddressNotAvailable->raise
          }

          newSession
        })
      }, (session, setSession))
    }
  }
}
