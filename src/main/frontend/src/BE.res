@val external fetch: (string,'a) => Js.Promise.t<'b> = "fetch"

type getDataReq = {
    id: int
}
type getDataResp = {
    data: array<string>
}
let getData: getDataReq => Js_promise.t<getDataResp> = req => fetch("/be/getAllData", {
    "method": "POST",
    "headers": {
        "Content-Type": "application/json;charset=UTF-8"
    },
    "body": Js.Json.stringifyAny(req)
})