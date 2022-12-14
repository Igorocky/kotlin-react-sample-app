package org.igye.kotlinreactsampleapp

import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("be")
class BeFunctions {
    data class GetAllDataRequest(val id: Long)
    data class GetAllDataResponse(val data: List<String>)
    @PostMapping("getAllData", consumes = ["application/json"], produces = ["application/json"])
    fun be(@RequestBody body: GetAllDataRequest): BeRespose<GetAllDataResponse> = BeRespose {
        println("body = '$body'")
        if (1 == 1) throw RuntimeException("RuntimeException...")
        GetAllDataResponse(data = listOf("ddd", "ffff", "rrerwer"))
    }
}