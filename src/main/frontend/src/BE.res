
open Expln_utils_jsonParse
let {exn} = module(Expln_utils_common)

@val external fetch: (string,'a) => Js_promise.t<{..}> = "fetch"

type beErr = {
    code: float,
    msg: string
}

type beResp<'a> = {
    data: Js.Option.t<'a>,
    err: Js.Option.t<beErr>,
}

type getDataReq = {
    id: int
}
type getDataResp = {
    data: array<string>
}

let promiseFlatMap = (p,m) => p -> Js.Promise.then_(m, _)
let promiseMap = (p,m) => p -> promiseFlatMap(x => Js_promise.resolve(m(x)))
let promiseCatchV = (p,m) => p -> Js.Promise.catch(err => {
    m(err)
    p
}, _)

let parseBeResp: (string, jsonAny=>'a) => beResp<'a> = (respStr:string, dataMapper:jsonAny=>'a) => switch parseObj(respStr, d => {
    data: d->objOpt("data", dataMapper),
    err: d->objOpt("err", d=>{
        code: d->num("code"),
        msg: d->str("msg"),
    }),
}) {
   | Ok(r) => r
   | Error(msg) => {
        Js_console.log2(`An error occured during parse of BE response: ${respStr}`, msg)
        exn(msg)
   }
}

let createBeFunction: (string, jsonAny => 'resp) => 'req => Js_promise.t<beResp<'resp>> = 
    (funcName, respMapper) => req => fetch(`/be/${funcName}`, {
        "method": "POST",
        "headers": {
            "Content-Type": "application/json;charset=UTF-8"
        },
        "body": Js.Json.stringifyAny(req)
    }) 
    -> promiseFlatMap(res => {
        Js.Console.log2(`response = `, res)
        res["text"](.) 
    })
    -> promiseMap(s => parseBeResp(s,respMapper))

let getData2: getDataReq => Js_promise.t<beResp<getDataResp>> = createBeFunction("getAllData", js => {
    data: js->arr("data", d => d->Js_json.stringifyAny -> Belt_Option.getExn)
})
