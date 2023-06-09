let reactQueryClient = ReactQuery.Provider.createClient()

@react.component
let make = (~children) => {
  <ReactQuery.Provider client=reactQueryClient> {children} </ReactQuery.Provider>
}
