type transactionVersion = string

type solanaMobileWalletAdapterErrorCode = {
  "ERROR_ASSOCIATION_PORT_OUT_OF_RANGE": string,
  "ERROR_FORBIDDEN_WALLET_BASE_URL": string,
  "ERROR_SECURE_CONTEXT_REQUIRED": string,
  "ERROR_SESSION_CLOSED": string,
  "ERROR_SESSION_TIMEOUT": string,
  "ERROR_WALLET_NOT_FOUND": string,
}

type portErrorData = {port: int}
type closeEventErrorData = {closeEvent: string}

type errorDataType =
  | PortErrorData(portErrorData)
  | CloseEventErrorData(closeEventErrorData)
  | NoErrorData

let makePortErrorData: portErrorData => errorDataType = errorData => PortErrorData(errorData)
let makeCloseEventErrorData: closeEventErrorData => errorDataType = errorData => CloseEventErrorData(
  errorData,
)
let makeNoErrorData: unit => errorDataType = _ => NoErrorData

type solanaMobileWalletAdapterError<'code> = {"data": errorDataType, "code": 'code}

type jsonRpcErrorCode = int

type solanaMobileWalletAdapterProtocolErrorCode = {
  "ERROR_AUTHORIZATION_FAILED": int,
  "ERROR_INVALID_PAYLOADS": int,
  "ERROR_NOT_SIGNED": int,
  "ERROR_NOT_SUBMITTED": int,
  "ERROR_TOO_MANY_PAYLOADS": int,
  "ERROR_ATTEST_ORIGIN_ANDROID": int,
}

type attestOriginErrorData = {attest_origin_uri: string, challenge: string, context: string}

type protocolErrorDataType =
  | AttestOriginErrorData(attestOriginErrorData)
  | NoProtocolErrorData

let makeAttestOriginErrorData: attestOriginErrorData => protocolErrorDataType = errorData => AttestOriginErrorData(
  errorData,
)

let makeNoProtocolErrorData: unit => protocolErrorDataType = _ => NoProtocolErrorData

type errorCodeVariant<'code> =
  | Code('code)
  | Rpc(jsonRpcErrorCode)

type solanaMobileWalletAdapterProtocolError<'code> = {
  data: protocolErrorDataType,
  code: errorCodeVariant<'code>,
  jsonRpcMessageId: int,
}

type account = {address: string, label: option<string>}

type appIdentity = {
  uri: option<string>,
  icon: option<string>,
  name: option<string>,
}

type associationKeypair = string // CryptoKeyPair is abstracted as string here

type authorizationResult = {
  accounts: array<account>,
  auth_token: string,
  wallet_uri_base: string,
}

type authToken = string
type base64EncodedAddress = string
type base64EncodedSignature = string
type base64EncodedMessage = string
type base64EncodedSignedMessage = string
type base64EncodedSignedTransaction = string
type base64EncodedTransaction = string

type walletAssociationConfig = {baseUri: option<string>}

type capabilities = {
  supports_clone_authorization: bool,
  supports_sign_and_send_transactions: bool,
  max_transactions_per_request: bool,
  max_messages_per_request: bool,
  supported_transaction_versions: array<transactionVersion>,
}

type authorizeApi = {
  cluster: Web3.cluster,
  identity: appIdentity,
}

type reauthorizeApi = {
  auth_token: authToken,
  identity: appIdentity,
}

type authorizeOptions = {cluster: Web3.cluster, identity: appIdentity}

type wallet = {
  authorize: authorizeApi => Js.Promise.t<authorizationResult>,
  reauthorize: reauthorizeApi => Js.Promise.t<authorizationResult>,
}

@send
external authorize: (wallet, authorizeOptions) => Js.Promise.t<authorizationResult> = "authorize"

type authorizationOptions = {auth_token: authToken}

@send
external cloneAuthorization: (wallet, authorizationOptions) => Js.Promise.t<authorizationOptions> =
  "cloneAuthorization"

type deauthorizeApi = {auth_token: authToken}
@send
external deauthorize: (wallet, deauthorizeApi) => Js.Promise.t<unit> = "deauthorize"

@send
external getCapabilities: wallet => Js.Promise.t<capabilities> = "getCapabilities"

@send
external reauthorize: (wallet, authorizeOptions) => Js.Promise.t<authorizationResult> =
  "reauthorize"

type signMessagesOptions = {
  addresses: array<base64EncodedAddress>,
  payloads: array<base64EncodedMessage>,
}

type signMessagesValue = {signed_payloads: array<base64EncodedSignedMessage>}

@send
external signMessages: (wallet, signMessagesOptions) => Js.Promise.t<signMessagesValue> =
  "signMessages"

type signTransactionsOptions = {payloads: array<base64EncodedTransaction>}

type signTransactionsValue = {signed_payloads: array<base64EncodedSignedTransaction>}

@send
external signTransactions: (
  wallet,
  signTransactionsOptions,
) => Js.Promise.t<signTransactionsValue> = "signTransactions"

type signAndSendTransactionsOptionsOptions = {
  @optional
  min_context_slot: option<int>,
}

type signAndSendTransactionsOptions = {
  @optional
  options: option<signAndSendTransactionsOptionsOptions>,
  payloads: array<base64EncodedTransaction>,
}

type signAndSendTransactionsValue = {signatures: array<base64EncodedSignature>}

@send
external signAndSendTransactions: (
  wallet,
  signAndSendTransactionsOptions,
) => Js.Promise.t<signAndSendTransactionsValue> = "signAndSendTransactions"

@module("@solana-mobile/mobile-wallet-adapter-protocol")
external transact: (
  wallet => Js.Promise.t<unit>,
  @optional option<walletAssociationConfig>,
) => Js.Promise.t<'return> = "transact"
