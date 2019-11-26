//
//  TKNGraphQLHelper.swift
//  TKNGraphQLHelper
//
//  Created by Alper Sevindik on 25.11.2019.
//  Copyright © 2019 Alper Sevindik. All rights reserved.
//
//
import Foundation

public class TKNGraphQLHelper {
    
    private let graphQLUrl: URL?
    private let bundle: Bundle
    
    /**
     *@param graphQLUrl: Url for graphQL requests
     *@param bundle: Bundle for graphQL query files.
     */
    public init(_ graphQLUrl: URL?, bundle: Bundle) {
        self.graphQLUrl = graphQLUrl
        self.bundle = bundle
    }
    /**
     *
     *Simple GraphQL request helper to get result of the query. Request graphql data with URLSession request.
     *
     *If you want to make your own request, you can use "createQueryBody" or "createQuery" functions.
     *
     *@param queryName: Query file name without .graphql extension
     *@param variables: Query parameters
     *@param headers: Request headers
     *@param success: Successful result block
     *@param failure: Failure result block
     */
    public func request<ReturnType: Decodable>(_ queryName: String,
                                               variables: Dictionary<String, TKNAnyEncodable>? = nil,
                                               headers: Dictionary<String, String> = ["Content-Type":"application/json"],
                                               success: @escaping (ReturnType) -> Void,
                                               failure: @escaping (String) -> Void) {
        
        if let graphQLUrl = graphQLUrl {
            let body = createQueryBody(queryName, variables: variables)
            
            let bodyData = try! JSONEncoder().encode(body)
            
            let defaultSession = URLSession(configuration: .default)
            
            var request = URLRequest(url: graphQLUrl)
            request.httpMethod = "POST"
            request.httpBody = bodyData
            headers.forEach { (key, value) in
                request.addValue(value, forHTTPHeaderField: key)
            }
            let dataTask = defaultSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    failure(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    
                    do {
                        let result = try JSONDecoder().decode(ReturnType.self, from: data)
                        success(result)
                    } catch {
                        failure("Decode error")
                    }
                }
            }
            dataTask.resume()
        } else {
            failure("URL is nil")
        }
    }
    
    /**
     * Creates TKNGraphQLQuery model to use on post request body.
     *
     *@param queryName: Query file name without .graphql extension
     *@param variables: Query parameters
     */
    public func createQueryBody(_ queryName: String, variables: Dictionary<String,TKNAnyEncodable>? = nil) -> TKNGraphQLQuery {
        return TKNGraphQLQuery(query: createQuery(queryName), variables: variables)
    }
    
    /**
     * Creates query/mutation string with fragment support for graphQL request.
     *
     *@param queryName: Query file name without .graphql extension
     */
    public func createQuery(_ queryName: String) -> String{
        var query = getContents(of: queryName)
        
        let fragmentContents = getFragmentContents(query)
        
        fragmentContents.forEach { (_, fragmentContent) in
            query.append("\n\n" + fragmentContent)
        }
        return query
    }
    
    private func getFragmentNames(_ query: String) -> Set<String> {
        do {
            let regex = try NSRegularExpression(pattern: #"\.\.\.(\s+)?([_A-Za-z][_0-9A-Za-z]*)"#)
            let results = regex.matches(in: query, range: NSRange(query.startIndex..., in: query))
            
            return Set(results.map {
                String(query[Range($0.range, in: query)!].dropFirst(3))
            })
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    private func getContents(of fileName: String) -> String {
        let path = bundle.path(forResource: fileName, ofType: "graphql")
        return try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
    }
    
    private func getFragmentContents(_ parentContent: String) -> [String: String] {
        var fragmentContents = [String: String]()
        let fragments = getFragmentNames(parentContent)
        fragments.forEach { fragmentName in
            let fragmentContent = getContents(of: fragmentName)
            fragmentContents[fragmentName] = fragmentContent
            fragmentContents.merge(getFragmentContents(fragmentContent)) { (current, _) -> String in current }
        }
        return fragmentContents
    }
}

