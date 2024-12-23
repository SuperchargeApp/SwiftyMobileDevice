//
//  InstallationProxyClient.swift
//  SwiftyMobileDevice
//
//  Created by Kabir Oberai on 14/11/19.
//  Copyright © 2019 Kabir Oberai. All rights reserved.
//

import Foundation
import Superutils
import libimobiledevice
import plist

private func requestCallbackC(command: plist_t?, status: plist_t?, userData: UnsafeMutableRawPointer?) {
    InstallationProxyClient.requestCallback(rawCommand: command, rawStatus: status, rawUserData: userData)
}

public final class InstallationProxyClient: LockdownService {

    public enum Error: CAPIError, LocalizedError {
        case unknown
        case `internal`
        case invalidArg
        case plistError
        case connFailed
        case opInProgress
        case opFailed
        case receiveTimeout
        case alreadyArchived
        case apiInternalError
        case applicationAlreadyInstalled
        case applicationMoveFailed
        case applicationSinfCaptureFailed
        case applicationSandboxFailed
        case applicationVerificationFailed
        case archiveDestructionFailed
        case bundleVerificationFailed
        case carrierBundleCopyFailed
        case carrierBundleDirectoryCreationFailed
        case carrierBundleMissingSupportedSims
        case commCenterNotificationFailed
        case containerCreationFailed
        case containerP0wnFailed
        case containerRemovalFailed
        case embeddedProfileInstallFailed
        case executableTwiddleFailed
        case existenceCheckFailed
        case installMapUpdateFailed
        case manifestCaptureFailed
        case mapGenerationFailed
        case missingBundleExecutable
        case missingBundleIdentifier
        case missingBundlePath
        case missingContainer
        case notificationFailed
        case packageExtractionFailed
        case packageInspectionFailed
        case packageMoveFailed
        case pathConversionFailed
        case restoreContainerFailed
        case seatbeltProfileRemovalFailed
        case stageCreationFailed
        case symlinkFailed
        case unknownCommand
        case itunesArtworkCaptureFailed
        case itunesMetadataCaptureFailed
        case deviceOsVersionTooLow
        case deviceFamilyNotSupported
        case packagePatchFailed
        case incorrectArchitecture
        case pluginCopyFailed
        case breadcrumbFailed
        case breadcrumbUnlockFailed
        case geojsonCaptureFailed
        case newsstandArtworkCaptureFailed
        case missingCommand
        case notEntitled
        case missingPackagePath
        case missingContainerPath
        case missingApplicationIdentifier
        case missingAttributeValue
        case lookupFailed
        case dictCreationFailed
        case installProhibited
        case uninstallProhibited
        case missingBundleVersion

        // swiftlint:disable:next cyclomatic_complexity function_body_length
        public init?(_ raw: instproxy_error_t) {
            switch raw {
            case INSTPROXY_E_SUCCESS:
                return nil
            case INSTPROXY_E_INVALID_ARG:
                self = .invalidArg
            case INSTPROXY_E_PLIST_ERROR:
                self = .plistError
            case INSTPROXY_E_CONN_FAILED:
                self = .connFailed
            case INSTPROXY_E_OP_IN_PROGRESS:
                self = .opInProgress
            case INSTPROXY_E_OP_FAILED:
                self = .opFailed
            case INSTPROXY_E_RECEIVE_TIMEOUT:
                self = .receiveTimeout
            case INSTPROXY_E_ALREADY_ARCHIVED:
                self = .alreadyArchived
            case INSTPROXY_E_API_INTERNAL_ERROR:
                self = .apiInternalError
            case INSTPROXY_E_APPLICATION_ALREADY_INSTALLED:
                self = .applicationAlreadyInstalled
            case INSTPROXY_E_APPLICATION_MOVE_FAILED:
                self = .applicationMoveFailed
            case INSTPROXY_E_APPLICATION_SINF_CAPTURE_FAILED:
                self = .applicationSinfCaptureFailed
            case INSTPROXY_E_APPLICATION_SANDBOX_FAILED:
                self = .applicationSandboxFailed
            case INSTPROXY_E_APPLICATION_VERIFICATION_FAILED:
                self = .applicationVerificationFailed
            case INSTPROXY_E_ARCHIVE_DESTRUCTION_FAILED:
                self = .archiveDestructionFailed
            case INSTPROXY_E_BUNDLE_VERIFICATION_FAILED:
                self = .bundleVerificationFailed
            case INSTPROXY_E_CARRIER_BUNDLE_COPY_FAILED:
                self = .carrierBundleCopyFailed
            case INSTPROXY_E_CARRIER_BUNDLE_DIRECTORY_CREATION_FAILED:
                self = .carrierBundleDirectoryCreationFailed
            case INSTPROXY_E_CARRIER_BUNDLE_MISSING_SUPPORTED_SIMS:
                self = .carrierBundleMissingSupportedSims
            case INSTPROXY_E_COMM_CENTER_NOTIFICATION_FAILED:
                self = .commCenterNotificationFailed
            case INSTPROXY_E_CONTAINER_CREATION_FAILED:
                self = .containerCreationFailed
            case INSTPROXY_E_CONTAINER_P0WN_FAILED:
                self = .containerP0wnFailed
            case INSTPROXY_E_CONTAINER_REMOVAL_FAILED:
                self = .containerRemovalFailed
            case INSTPROXY_E_EMBEDDED_PROFILE_INSTALL_FAILED:
                self = .embeddedProfileInstallFailed
            case INSTPROXY_E_EXECUTABLE_TWIDDLE_FAILED:
                self = .executableTwiddleFailed
            case INSTPROXY_E_EXISTENCE_CHECK_FAILED:
                self = .existenceCheckFailed
            case INSTPROXY_E_INSTALL_MAP_UPDATE_FAILED:
                self = .installMapUpdateFailed
            case INSTPROXY_E_MANIFEST_CAPTURE_FAILED:
                self = .manifestCaptureFailed
            case INSTPROXY_E_MAP_GENERATION_FAILED:
                self = .mapGenerationFailed
            case INSTPROXY_E_MISSING_BUNDLE_EXECUTABLE:
                self = .missingBundleExecutable
            case INSTPROXY_E_MISSING_BUNDLE_IDENTIFIER:
                self = .missingBundleIdentifier
            case INSTPROXY_E_MISSING_BUNDLE_PATH:
                self = .missingBundlePath
            case INSTPROXY_E_MISSING_CONTAINER:
                self = .missingContainer
            case INSTPROXY_E_NOTIFICATION_FAILED:
                self = .notificationFailed
            case INSTPROXY_E_PACKAGE_EXTRACTION_FAILED:
                self = .packageExtractionFailed
            case INSTPROXY_E_PACKAGE_INSPECTION_FAILED:
                self = .packageInspectionFailed
            case INSTPROXY_E_PACKAGE_MOVE_FAILED:
                self = .packageMoveFailed
            case INSTPROXY_E_PATH_CONVERSION_FAILED:
                self = .pathConversionFailed
            case INSTPROXY_E_RESTORE_CONTAINER_FAILED:
                self = .restoreContainerFailed
            case INSTPROXY_E_SEATBELT_PROFILE_REMOVAL_FAILED:
                self = .seatbeltProfileRemovalFailed
            case INSTPROXY_E_STAGE_CREATION_FAILED:
                self = .stageCreationFailed
            case INSTPROXY_E_SYMLINK_FAILED:
                self = .symlinkFailed
            case INSTPROXY_E_UNKNOWN_COMMAND:
                self = .unknownCommand
            case INSTPROXY_E_ITUNES_ARTWORK_CAPTURE_FAILED:
                self = .itunesArtworkCaptureFailed
            case INSTPROXY_E_ITUNES_METADATA_CAPTURE_FAILED:
                self = .itunesMetadataCaptureFailed
            case INSTPROXY_E_DEVICE_OS_VERSION_TOO_LOW:
                self = .deviceOsVersionTooLow
            case INSTPROXY_E_DEVICE_FAMILY_NOT_SUPPORTED:
                self = .deviceFamilyNotSupported
            case INSTPROXY_E_PACKAGE_PATCH_FAILED:
                self = .packagePatchFailed
            case INSTPROXY_E_INCORRECT_ARCHITECTURE:
                self = .incorrectArchitecture
            case INSTPROXY_E_PLUGIN_COPY_FAILED:
                self = .pluginCopyFailed
            case INSTPROXY_E_BREADCRUMB_FAILED:
                self = .breadcrumbFailed
            case INSTPROXY_E_BREADCRUMB_UNLOCK_FAILED:
                self = .breadcrumbUnlockFailed
            case INSTPROXY_E_GEOJSON_CAPTURE_FAILED:
                self = .geojsonCaptureFailed
            case INSTPROXY_E_NEWSSTAND_ARTWORK_CAPTURE_FAILED:
                self = .newsstandArtworkCaptureFailed
            case INSTPROXY_E_MISSING_COMMAND:
                self = .missingCommand
            case INSTPROXY_E_NOT_ENTITLED:
                self = .notEntitled
            case INSTPROXY_E_MISSING_PACKAGE_PATH:
                self = .missingPackagePath
            case INSTPROXY_E_MISSING_CONTAINER_PATH:
                self = .missingContainerPath
            case INSTPROXY_E_MISSING_APPLICATION_IDENTIFIER:
                self = .missingApplicationIdentifier
            case INSTPROXY_E_MISSING_ATTRIBUTE_VALUE:
                self = .missingAttributeValue
            case INSTPROXY_E_LOOKUP_FAILED:
                self = .lookupFailed
            case INSTPROXY_E_DICT_CREATION_FAILED:
                self = .dictCreationFailed
            case INSTPROXY_E_INSTALL_PROHIBITED:
                self = .installProhibited
            case INSTPROXY_E_UNINSTALL_PROHIBITED:
                self = .uninstallProhibited
            case INSTPROXY_E_MISSING_BUNDLE_VERSION:
                self = .missingBundleVersion
            default:
                self = .unknown
            }
        }

        public var errorDescription: String? {
            "InstallationProxyClient.Error.\(self)"
        }
    }

    public struct StatusError: LocalizedError {
        public let type: Error
        public let name: String
        public let details: String?
        public let code: Int

        init?(raw: plist_t) {
            var rawName: UnsafeMutablePointer<Int8>?
            var rawDetails: UnsafeMutablePointer<Int8>?
            var rawCode: UInt64 = 0
            guard let type = Error(instproxy_status_get_error(raw, &rawName, &rawDetails, &rawCode)),
                let name = rawName.flatMap({
                    String(bytesNoCopy: $0, length: strlen($0), encoding: .utf8, freeWhenDone: true)
                })
                else { return nil }

            self.type = type
            self.name = name
            self.details = rawDetails.flatMap {
                String(bytesNoCopy: $0, length: strlen($0), encoding: .utf8, freeWhenDone: true)
            }
            self.code = .init(rawCode)
        }

        public var errorDescription: String? {
            "\(name) (0x\(String(code, radix: 16)))\(details.map { ": \($0)" } ?? "")"
        }
    }

    public struct RequestProgress {
        public let details: String
        public let progress: Double?
    }

    // open so that extra options may be added
    open class Options: Encodable {
        public var skipUninstall: Bool?
        public var applicationSINF: Data?
        public var itunesMetadata: Data?
        public var applicationType: String?
        public var returnAttributes: [String]?
        public var additionalOptions: [String: String] = [:]

        private enum CodingKeys: String, CodingKey {
            case skipUninstall = "SkipUninstall"
            case applicationSINF = "ApplicationSINF"
            case itunesMetadata = "iTunesMetadata"
            case applicationType = "ApplicationType"
            case returnAttributes = "ReturnAttributes"
        }

        public func encode(to encoder: Encoder) throws {
            var keyedContainer = encoder.container(keyedBy: CodingKeys.self)
            try skipUninstall.map { try keyedContainer.encode($0, forKey: .skipUninstall) }
            try applicationSINF.map { try keyedContainer.encode($0, forKey: .applicationSINF) }
            try itunesMetadata.map { try keyedContainer.encode($0, forKey: .itunesMetadata) }
            try applicationType.map { try keyedContainer.encode($0, forKey: .applicationType) }
            try returnAttributes.map { try keyedContainer.encode($0, forKey: .returnAttributes) }
            try additionalOptions.encode(to: encoder)
        }

        public init(
            skipUninstall: Bool? = nil,
            applicationSINF: Data? = nil,
            itunesMetadata: Data? = nil,
            applicationType: String? = nil,
            returnAttributes: [String]? = nil,
            additionalOptions: [String: String] = [:]
        ) {
            self.skipUninstall = skipUninstall
            self.applicationSINF = applicationSINF
            self.itunesMetadata = itunesMetadata
            self.applicationType = applicationType
            self.returnAttributes = returnAttributes
            self.additionalOptions = additionalOptions
        }
    }

    private final class RequestUserData: Sendable {
        enum Updater: Sendable {
            // list is moved
            case browse(@Sendable (_ currIndex: Int, _ total: Int, _ list: plist_t?) -> Void)
            case progress(@Sendable (RequestProgress) -> Void)
        }

        let updater: Updater
        let completion: @Sendable (Result<(), Swift.Error>) -> Void
        private let stream: AsyncThrowingStream<Never, Swift.Error>

        init(updater: Updater) {
            let (stream, continuation) = AsyncThrowingStream<Never, Swift.Error>.makeStream()
            self.updater = updater
            self.completion = { result in
                switch result {
                case .success:
                    continuation.finish()
                case .failure(let error):
                    continuation.finish(throwing: error)
                }
            }
            self.stream = stream
        }

        func opaque() -> UnsafeMutableRawPointer {
            Unmanaged.passUnretained(self).toOpaque()
        }

        func waitForCompletion() async throws {
            for try await _ in stream {}
        }
    }

    public typealias Raw = instproxy_client_t
    public static let serviceIdentifier = INSTPROXY_SERVICE_NAME
    public static nonisolated(unsafe) let newFunc: NewFunc = instproxy_client_new
    public static nonisolated(unsafe) let startFunc: StartFunc = instproxy_client_start_service
    public nonisolated(unsafe) let raw: instproxy_client_t
    public required init(raw: instproxy_client_t) { self.raw = raw }
    deinit { instproxy_client_free(raw) }

    private let encoder = PlistNodeEncoder()
    private let decoder = PlistNodeDecoder()

    fileprivate static func requestCallback(rawCommand: plist_t?, rawStatus: plist_t?, rawUserData: UnsafeMutableRawPointer?) {
        let userData = Unmanaged<RequestUserData>.fromOpaque(rawUserData!).takeUnretainedValue()

        func complete(_ result: Result<(), Swift.Error>) {
            userData.completion(result)
        }

        if let error = StatusError(raw: rawStatus!) {
            return complete(.failure(error))
        }

        let statusName = Result {
            try CAPI<CAPINoError>.getString {
                instproxy_status_get_name(rawStatus, &$0)
            }
        }
        let isComplete = (try? statusName.get()) == "Complete"

        switch userData.updater {
        case .browse(let callback):
            var total: UInt64 = 0
            var currIndex: UInt64 = 0
            var currAmount: UInt64 = 0
            var list: plist_t?
            instproxy_status_get_current_list(rawStatus, &total, &currIndex, &currAmount, &list)
            callback(Int(currIndex), Int(total), list)
            if isComplete { complete(.success(())) }
        case .progress(let callback):
            let progress: Double?
            if isComplete {
                progress = 1
            } else {
                var rawPercent: Int32 = -1
                instproxy_status_get_percent_complete(rawStatus, &rawPercent)
                progress = rawPercent >= 0 ? (Double(rawPercent) / 100) : nil
            }
            statusName.get(withErrorHandler: complete).map {
                callback(.init(details: $0, progress: progress))
            }
            if isComplete { return complete(.success(())) }
        }
    }

    public func install(
        package: URL,
        upgrade: Bool = false,
        options: Options = .init(),
        progress: @escaping @Sendable (RequestProgress) -> Void
    ) async throws {
        let userData = RequestUserData(updater: .progress(progress))

        let fn = upgrade ? instproxy_upgrade : instproxy_install

        // Note: build performance
        let err = try encoder.withEncoded(options) { (rawOptions: plist_t) -> instproxy_error_t in
            package.withUnsafeFileSystemRepresentation { (path: UnsafePointer<Int8>?) -> instproxy_error_t in
                fn(raw, path, rawOptions, requestCallbackC, userData.opaque())
            }
        }
        try CAPI<Error>.check(err)

        try await userData.waitForCompletion()
    }

    public func uninstall(
        bundleID: String,
        options: Options = .init(),
        progress: @escaping @Sendable (RequestProgress) -> Void
    ) async throws {
        let userData = RequestUserData(updater: .progress(progress))

        let err = try encoder.withEncoded(options) { (rawOptions: plist_t) -> instproxy_error_t in
            instproxy_uninstall(raw, bundleID, rawOptions, requestCallbackC, userData.opaque())
        }
        try CAPI<Error>.check(err)

        try await userData.waitForCompletion()
    }

    public func archive(
        app: String,
        options: Options = .init(),
        progress: @escaping @Sendable (RequestProgress) -> Void
    ) async throws {
        let userData = RequestUserData(updater: .progress(progress))

        try encoder.withEncoded(options) {
            try CAPI<Error>.check(instproxy_archive(raw, app, $0, requestCallbackC, userData.opaque()))
        }

        try await userData.waitForCompletion()
    }

    public func restore(
        app: String,
        options: Options = .init(),
        progress: @escaping @Sendable (RequestProgress) -> Void
    ) async throws {
        let userData = RequestUserData(updater: .progress(progress))

        try encoder.withEncoded(options) {
            try CAPI<Error>.check(instproxy_restore(raw, app, $0, requestCallbackC, userData.opaque()))
        }

        try await userData.waitForCompletion()
    }

    public func lookupArchives<T: Decodable>(resultType: T.Type) throws -> [String: T] {
        return try decoder.decode([String: T].self) { (result: inout plist_t?) throws -> Void in
            try CAPI<Error>.check(instproxy_lookup_archives(raw, nil, &result))
        }
    }

    public func removeArchive(
        app: String,
        progress: @escaping @Sendable (RequestProgress) -> Void
    ) async throws {
        let userData = RequestUserData(updater: .progress(progress))
        try CAPI<Error>.check(instproxy_remove_archive(raw, app, nil, requestCallbackC, userData.opaque()))
        try await userData.waitForCompletion()
    }

    public func lookup<T: Decodable>(
        resultType: T.Type,
        apps: [String],
        options: Options = .init()
    ) throws -> [String: T] {
        let rawIDs = apps.map { strdup($0) }
        defer { rawIDs.forEach { $0.map { free($0) } } }

        var ids = rawIDs.map { UnsafePointer($0) }

        return try decoder.decode([String: T].self) { (result: inout plist_t?) throws -> Void in
            try encoder.withEncoded(options) { (rawOpts: plist_t) throws -> Void in
                try CAPI<Error>.check(instproxy_lookup(raw, &ids, rawOpts, &result))
            }
        }
    }

    public func browse<T: Decodable>(
        resultType: T.Type,
        options: Options = .init(),
        progress: @escaping @Sendable (_ currIndex: Int, _ total: Int, _ apps: Result<[T], Swift.Error>) -> Void
    ) async throws {
        let updater = RequestUserData.Updater.browse { currIdx, total, rawApps in
            let apps = rawApps.map { unwrapped in
                Result { try self.decoder.decode([T].self, moving: unwrapped) }
            } ?? .success([])
            progress(currIdx, total, apps)
        }
        let userData = RequestUserData(updater: updater)
        try encoder.withEncoded(options) { rawOpts in
            instproxy_browse_with_callback(raw, rawOpts, requestCallbackC, userData.opaque())
        }
        try await userData.waitForCompletion()
    }

    public func executable(forBundleID bundleID: String) throws -> URL {
        var rawPath: UnsafeMutablePointer<Int8>?
        try CAPI<Error>.check(instproxy_client_get_path_for_bundle_identifier(raw, bundleID, &rawPath))
        guard let path = rawPath else { throw CAPIGenericError.unexpectedNil }
        return URL(fileURLWithFileSystemRepresentation: path, isDirectory: false, relativeTo: nil)
    }

}
