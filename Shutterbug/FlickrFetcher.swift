//
//  FlickrFetcher.swift
//  Shutterbug
//
//  Created for Stanford CS193p Fall 2013.
//  Copyright 2013 Stanford University. All rights reserved.
//

import Foundation

let FlickrAPIKey = "1ca4f673ccb9c5a2069593d7982e41c6"

// key paths to photos or places at top-level of Flickr results
let FLICKR_RESULTS_PHOTOS = "photos.photo"
let FLICKR_RESULTS_PLACES = "places.place"

// keys (paths) to values in a photo dictionary
let FLICKR_PHOTO_TITLE =        "title"
let FLICKR_PHOTO_DESCRIPTION =  "description._content"
let FLICKR_PHOTO_ID =           "id"
let FLICKR_PHOTO_OWNER =        "ownername"
let FLICKR_PHOTO_UPLOAD_DATE =  "dateupload" // in seconds since 1970
let FLICKR_PHOTO_PLACE_ID =     "place_id"

// keys (paths) to values in a places dictionary (from TopPlaces)
let FLICKR_PLACE_NAME = "_content"
let FLICKR_PLACE_ID =   "place_id"

// keys applicable to all types of Flickr dictionaries
let FLICKR_LATITUDE =   "latitude"
let FLICKR_LONGITUDE =  "longitude"
let FLICKR_TAGS =       "tags"

let FLICKR_PLACE_NEIGHBORHOOD_NAME =        "place.neighbourhood._content"
let FLICKR_PLACE_NEIGHBORHOOD_PLACE_ID =    "place.neighbourhood.place_id"
let FLICKR_PLACE_LOCALITY_NAME =            "place.locality._content"
let FLICKR_PLACE_LOCALITY_PLACE_ID =        "place.locality.place_id"
let FLICKR_PLACE_REGION_NAME =              "place.region._content"
let FLICKR_PLACE_REGION_PLACE_ID =          "place.region.place_id"
let FLICKR_PLACE_COUNTY_NAME =              "place.county._content"
let FLICKR_PLACE_COUNTY_PLACE_ID =          "place.county.place_id"
let FLICKR_PLACE_COUNTRY_NAME =             "place.country._content"
let FLICKR_PLACE_COUNTRY_PLACE_ID =         "place.country.place_id"
let FLICKR_PLACE_REGION =                   "place.region"


enum FlickrPhotoFormat : Int, Printable {
    case Square = 1,    // thumbnail
         Large = 2,     // normal size
         Original = 64  // high resolution
    
    var description : String {
    switch self {
    case .Square:   return "s"
    case .Large:    return "b"
    case .Original: return "o"
    }
    }
}

class FlickrFetcher {
    
    internal class func URLForQuery(query: String) -> NSURL! {
        var tmp = "\(query)&format=json&nojsoncallback=1&api_key=\(FlickrAPIKey)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        if let str = tmp {
            return NSURL.URLWithString(str)
        }
        return nil
    }

    class func URLForTopPlaces() -> NSURL! {
        return FlickrFetcher.URLForQuery("https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7")
        
    }
    
    class func URLforPhotosInPlace(flickrPlaceId: AnyObject, maxResults: Int) -> NSURL! {
        return FlickrFetcher.URLForQuery("https://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=\(flickrPlaceId)&per_page=\(maxResults)&extras=original_format,tags,description,geo,date_upload,owner_name,place_url")
    }
    
    class func URLforRecentGeoreferencedPhotos() -> NSURL! {
        return FlickrFetcher.URLForQuery("https://api.flickr.com/services/rest/?method=flickr.photos.search&license=1,2,4,7&has_geo=1&extras=original_format,description,geo,date_upload,owner_name");

    }
    
    internal class func URLStringForPhoto(photo: NSDictionary, format: FlickrPhotoFormat) -> String! {
        let farm: AnyObject? = photo.objectForKey("farm")
        let server: AnyObject? = photo.objectForKey("server")
        let photo_id: AnyObject? = photo.objectForKey("id")
        let secret: AnyObject? = format == FlickrPhotoFormat.Original ? photo.objectForKey("originalsecret") : photo.objectForKey("secret")
        let fileType: String? = format == FlickrPhotoFormat.Original ? photo.objectForKey("originalformat") as? String : "jpg"
        
        if farm == nil || server == nil || photo_id == nil || secret == nil {
            return nil
        }
        
        return "http://farm\(farm!).static.flickr.com/\(server!)/\(photo_id!)_\(secret!)_\(format).\(fileType!)"
    }
    
    class func URLforPhoto(photo: NSDictionary, format: FlickrPhotoFormat) -> NSURL! {
        let str = FlickrFetcher.URLStringForPhoto(photo, format: format)
        return str != nil ? NSURL(string: str) : nil
    }
    
    class func URLforInformationAboutPlace(flickrPlaceId: AnyObject) -> NSURL! {
        return FlickrFetcher.URLForQuery("https://api.flickr.com/services/rest/?method=flickr.places.getInfo&place_id=\(flickrPlaceId)")
    }
    
    class func extractNameOfPlace(placeId: AnyObject, fromPlaceInformation place: NSDictionary) -> String? {

        
        if let str = place.valueForKeyPath(FLICKR_PLACE_NEIGHBORHOOD_PLACE_ID) as? String {
            if placeId.isEqualToString(str) {
              return str
            }
        }
        else if let str = place.valueForKeyPath(FLICKR_PLACE_LOCALITY_PLACE_ID) as? String {
            
            if placeId.isEqualToString(str) {
                return str
            }
        }
        else if let str = place.valueForKeyPath(FLICKR_PLACE_COUNTY_PLACE_ID) as? String {
            
            if placeId.isEqualToString(str) {
                return str
            }
        }
        else if let str = place.valueForKeyPath(FLICKR_PLACE_REGION_PLACE_ID) as? String {
            
            if placeId.isEqualToString(str) {
                return str
            }
        }
        else if let str = place.valueForKeyPath(FLICKR_PLACE_COUNTRY_PLACE_ID) as? String {
            
            if placeId.isEqualToString(str) {
                return str
            }
        }

        return nil
    }
    
    class func extractRegionNameFromPlaceInformation(placeInformation place: NSDictionary) -> String! {
        return place.valueForKeyPath(FLICKR_PLACE_REGION_NAME) as? String
    }

}