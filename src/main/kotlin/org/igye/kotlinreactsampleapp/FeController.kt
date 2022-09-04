package org.igye.kotlinreactsampleapp

import org.apache.commons.io.IOUtils
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseBody
import java.nio.charset.StandardCharsets
import javax.servlet.http.HttpServletRequest

@Controller
@RequestMapping("")
@ResponseBody
class FeController(
    @Value("\${app.version}")
    private val appVersion: String,
) {
    @GetMapping("**")
    fun index(request: HttpServletRequest): ResponseEntity<ByteArray> {
        println("request.requestURI = ${request.requestURI}")
        return ResponseEntity<ByteArray>(
            readFileToString(getFilePath(request.requestURI))
                .replace("@app\\.version@".toRegex(), appVersion)
                .toByteArray(StandardCharsets.UTF_8),
            HttpStatus.OK
        )
    }

    private fun getFilePath(requestURI: String): String {
        return if (requestURI == "/") "/frontend/index.html"
        else "/frontend$requestURI"
    }

    private fun readFileToString(filePath: String): String {
        return IOUtils.toString(this.javaClass.getResourceAsStream(filePath), StandardCharsets.UTF_8)
    }
}