import Foundation

class FileHelper {
    class func audio1URL() -> URL! {
        return fileURL(for: "sample_audio1", fileExtension: "mp3")
    }

    class func audio2URL() -> URL! {
        return fileURL(for: "sample_audio2", fileExtension: "mp3")
    }

    class func movie1URL() -> URL! {
        return fileURL(for: "sample_movie", fileExtension: "mp4")
    }

    private class func fileURL(for baseName: String, fileExtension: String) -> URL! {
        return Bundle(for: self).url(forResource: baseName, withExtension: fileExtension)
    }
}
