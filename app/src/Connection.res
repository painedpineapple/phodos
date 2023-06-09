let endpoint = Web3.clusterApiUrl(~cluster=Env.cluster, ())

let connection = Web3.Connection.make(
  endpoint,
  {
    commitment: #confirmed,
  },
)

module Balance = {
  let lamportsPerSol = 1000000000.
  let fetchBalance = async (account: Auth.account) => {
    let inLamports = await connection->Web3.Connection.getBalance(account.publicKey, ())
    inLamports->float_of_int /. lamportsPerSol
  }

  let use = (account: Auth.account) => {
    ReactQuery.useQuery({
      queryFn: _ => fetchBalance(account),
      queryKey: ["balance", account.publicKey->Web3.PublicKey.toString],
    })
  }
}
