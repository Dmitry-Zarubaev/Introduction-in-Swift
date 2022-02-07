//
//  Lesson_7.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 04.02.2022.
//

import Foundation

enum HTTPRequestMethod {
    case GET(parameters: [HTTPParameter])
    case POST(parameters: [HTTPParameter])
    case HEAD
    case PUT
    case DELETE
    case CONNECT
    case OPTIONS
    case TRACE
    case PATCH
}

struct HTTPParameter {
    let key: String
    let value: String?
    
    init(key: String, value: String? = nil) {
        self.key = key
        self.value = value
    }
    
    var parameter: String {
        if let value = self.value {
            return key + "=" + value
        } else {
            return key
        }
    }
}

struct HTTPHeader {
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    var header: String {
        return name + ":" + value
    }
}

struct HTTPResponse {
    let code: Int
    let status: String
    let httpProtocol: String
    let headers: [HTTPHeader]
    
    var body: String?
}

struct MyCustomError: Error {
    let message: String
}

struct HTTPRequest {
    let url: String
    let method: HTTPRequestMethod
    let headers: [HTTPHeader]
    private(set) var httpProtocol: String = "HTTP/1.1"

    init(url: String, method: HTTPRequestMethod, headers: [HTTPHeader], protocol: String? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        if let prot = `protocol` {
            self.httpProtocol = prot
        }
    }
    
    public func perform() async throws -> HTTPResponse {
        guard isSupportedMethod() else {
            fatalError("Not implemented")
        }
        
        do {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        } catch {
            print("Something bad happened")
        }
        
        let response = simulateRequest()
        
        switch response.code {
            case let x where x < 200:
                throw MyCustomError(message: "Information response: \(x)")
            case let x where x >= 200 && x < 300:
                return response
            case let x where x >= 300 && x < 400:
                throw MyCustomError(message: "Redirection response: \(x)")
            case 404:
                throw MyCustomError(message: "Description NOT FOUND")
            case let x where x >= 400 && x < 500:
                throw MyCustomError(message: "Client error: \(x)")
            case let x where x >= 500 && x < 600:
                throw MyCustomError(message: "Server error: \(x)")
            default:
                throw MyCustomError(message: "Unknown code")
        }
    }
    
    private func isSupportedMethod() -> Bool {
        switch self.method {
            case .GET(_), .POST(_):
                return true
            default:
                return false
        }
    }
    
    private func simulateRequest() -> HTTPResponse {
        let otherCodes: [Int] = [
            100, 101, 102, 103,
            200, 201, 202, 203, 204, 205, 206, 207, 208, 226,
            300, 301, 302, 303, 304, 305, 306, 307, 308,
            400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 425, 426, 428, 429, 431, 451,
            500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511
        ]
        
        var codes: [Int] = Array(repeating: 200, count: otherCodes.count)
        codes.append(contentsOf: otherCodes)
        
        let headers: [HTTPHeader] = [
            HTTPHeader(name: "Connection", value: "close"),
            HTTPHeader(name: "Content-Type", value: "application/json")
        ]
        
        // http://example.com
        let body: String = """
            <!doctype html>
            <html>
            <head>
                <title>Example Domain</title>
            
                <meta charset="utf-8" />
                <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <style type="text/css">
                body {
                    background-color: #f0f0f2;
                    margin: 0;
                    padding: 0;
                    font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
            
                }
                div {
                    width: 600px;
                    margin: 5em auto;
                    padding: 2em;
                    background-color: #fdfdff;
                    border-radius: 0.5em;
                    box-shadow: 2px 3px 7px 2px rgba(0,0,0,0.02);
                }
                a:link, a:visited {
                    color: #38488f;
                    text-decoration: none;
                }
                @media (max-width: 700px) {
                    div {
                        margin: 0 auto;
                        width: auto;
                    }
                }
                </style>
            </head>
            
            <body>
            <div>
                <h1>Example Domain</h1>
                <p>This domain is for use in illustrative examples in documents. You may use this
                domain in literature without prior coordination or asking for permission.</p>
                <p><a href="https://www.iana.org/domains/example">More information...</a></p>
            </div>
            </body>
            </html>
        """
        
        return HTTPResponse(code: codes.randomElement() ?? 200, status: "OK", httpProtocol: "HTTP/1.1", headers: headers, body: Int.random(in: 0...10) > 5 ? body : nil)
    }
}


func handleFakeHttpRequest() async -> Void {
    print("We are going to perform a HTTP request")
    let fatalMethods: [HTTPRequestMethod] = [
        .HEAD,
        .PUT,
        .DELETE,
        .CONNECT,
        .OPTIONS,
        .TRACE,
        .PATCH,
    ]
    var methods = Array(repeating: HTTPRequestMethod.GET(parameters: []), count: 20)
    methods.append(contentsOf: fatalMethods)
    
    let request = HTTPRequest(url: "http://example.com", method: methods.randomElement() ?? .GET(parameters: []), headers: [])
    
    Task {
        do {
            let response = try await request.perform()
            
            if let body = response.body {
                print(body)
            } else {
                print("Response: \(response.code)")
            }
        } catch let error as MyCustomError {
            print("Response result: \(error.message)")
        } catch {
            print("Unexpected error: \(error).")
        }
    }
}

let lesson7: Array<(String, () async -> Void)> = [
    ("1. Let's try a HTTP request", handleFakeHttpRequest)
]
