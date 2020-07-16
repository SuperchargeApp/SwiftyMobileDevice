//
//  LockdownClient.swift
//  SwiftyMobileDevice
//
//  Created by Kabir Oberai on 13/11/19.
//  Copyright © 2019 Kabir Oberai. All rights reserved.
//

import Foundation

public class LockdownClient {

    public enum Error: CAPIError, LocalizedError {
        case unknown
        case `internal`
        case invalidArg
        case invalidConf
        case plistError
        case pairingFailed
        case sslError
        case dictError
        case receiveTimeout
        case muxError
        case noRunningSession
        case invalidResponse
        case missingKey
        case missingValue
        case getProhibited
        case setProhibited
        case removeProhibited
        case immutableValue
        case passwordProtected
        case userDeniedPairing
        case pairingDialogResponsePending
        case missingHostID
        case invalidHostID
        case sessionActive
        case sessionInactive
        case missingSessionID
        case invalidSessionID
        case missingService
        case invalidService
        case serviceLimit
        case missingPairRecord
        case savePairRecordFailed
        case invalidPairRecord
        case invalidActivationRecord
        case missingActivationRecord
        case serviceProhibited
        case escrowLocked
        case pairingProhibitedOverThisConnection
        case fmipProtected
        case mcProtected
        case mcChallengeRequired

        public init?(_ raw: lockdownd_error_t) {
            switch raw {
            case LOCKDOWN_E_SUCCESS:
                return nil
            case LOCKDOWN_E_INVALID_ARG:
                self = .invalidArg
            case LOCKDOWN_E_INVALID_CONF:
                self = .invalidConf
            case LOCKDOWN_E_PLIST_ERROR:
                self = .plistError
            case LOCKDOWN_E_PAIRING_FAILED:
                self = .pairingFailed
            case LOCKDOWN_E_SSL_ERROR:
                self = .sslError
            case LOCKDOWN_E_DICT_ERROR:
                self = .dictError
            case LOCKDOWN_E_RECEIVE_TIMEOUT:
                self = .receiveTimeout
            case LOCKDOWN_E_MUX_ERROR:
                self = .muxError
            case LOCKDOWN_E_NO_RUNNING_SESSION:
                self = .noRunningSession
            case LOCKDOWN_E_INVALID_RESPONSE:
                self = .invalidResponse
            case LOCKDOWN_E_MISSING_KEY:
                self = .missingKey
            case LOCKDOWN_E_MISSING_VALUE:
                self = .missingValue
            case LOCKDOWN_E_GET_PROHIBITED:
                self = .getProhibited
            case LOCKDOWN_E_SET_PROHIBITED:
                self = .setProhibited
            case LOCKDOWN_E_REMOVE_PROHIBITED:
                self = .removeProhibited
            case LOCKDOWN_E_IMMUTABLE_VALUE:
                self = .immutableValue
            case LOCKDOWN_E_PASSWORD_PROTECTED:
                self = .passwordProtected
            case LOCKDOWN_E_USER_DENIED_PAIRING:
                self = .userDeniedPairing
            case LOCKDOWN_E_PAIRING_DIALOG_RESPONSE_PENDING:
                self = .pairingDialogResponsePending
            case LOCKDOWN_E_MISSING_HOST_ID:
                self = .missingHostID
            case LOCKDOWN_E_INVALID_HOST_ID:
                self = .invalidHostID
            case LOCKDOWN_E_SESSION_ACTIVE:
                self = .sessionActive
            case LOCKDOWN_E_SESSION_INACTIVE:
                self = .sessionInactive
            case LOCKDOWN_E_MISSING_SESSION_ID:
                self = .missingSessionID
            case LOCKDOWN_E_INVALID_SESSION_ID:
                self = .invalidSessionID
            case LOCKDOWN_E_MISSING_SERVICE:
                self = .missingService
            case LOCKDOWN_E_INVALID_SERVICE:
                self = .invalidService
            case LOCKDOWN_E_SERVICE_LIMIT:
                self = .serviceLimit
            case LOCKDOWN_E_MISSING_PAIR_RECORD:
                self = .missingPairRecord
            case LOCKDOWN_E_SAVE_PAIR_RECORD_FAILED:
                self = .savePairRecordFailed
            case LOCKDOWN_E_INVALID_PAIR_RECORD:
                self = .invalidPairRecord
            case LOCKDOWN_E_INVALID_ACTIVATION_RECORD:
                self = .invalidActivationRecord
            case LOCKDOWN_E_MISSING_ACTIVATION_RECORD:
                self = .missingActivationRecord
            case LOCKDOWN_E_SERVICE_PROHIBITED:
                self = .serviceProhibited
            case LOCKDOWN_E_ESCROW_LOCKED:
                self = .escrowLocked
            case LOCKDOWN_E_PAIRING_PROHIBITED_OVER_THIS_CONNECTION:
                self = .pairingProhibitedOverThisConnection
            case LOCKDOWN_E_FMIP_PROTECTED:
                self = .fmipProtected
            case LOCKDOWN_E_MC_PROTECTED:
                self = .mcProtected
            case LOCKDOWN_E_MC_CHALLENGE_REQUIRED:
                self = .mcChallengeRequired
            default:
                self = .unknown
            }
        }

        public var errorDescription: String? {
            "LockdownClient.Error.\(self)"
        }
    }

    public class ServiceDescriptor<T: LockdownService> {

        public let raw: lockdownd_service_descriptor_t
        public init(raw: lockdownd_service_descriptor_t) { self.raw = raw }
        public init(client: LockdownClient, sendEscrowBag: Bool = false) throws {
            var descriptor: lockdownd_service_descriptor_t?
            try CAPI<Error>.check(
                (sendEscrowBag ? lockdownd_start_service_with_escrow_bag : lockdownd_start_service)(
                    client.raw, T.serviceIdentifier, &descriptor
                )
            )
            guard let raw = descriptor else { throw Error.internal }
            self.raw = raw
        }
        deinit { lockdownd_service_descriptor_free(raw) }

        public var port: UInt16 {
            get { raw.pointee.port }
            set { raw.pointee.port = newValue }
        }

        public var isSSLEnabled: Bool {
            get { raw.pointee.ssl_enabled != 0 }
            set { raw.pointee.ssl_enabled = newValue ? 1 : 0 }
        }

    }

    public struct SessionID: RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }

    public class PairRecord {
        public let raw: lockdownd_pair_record_t
        public init(raw: lockdownd_pair_record_t) {
            self.raw = raw
        }
    }

    private let encoder = PlistNodeEncoder()
    private let decoder = PlistNodeDecoder()

    public let raw: lockdownd_client_t
    public init(raw: lockdownd_client_t) { self.raw = raw }
    public init(device: Device, label: String?, performHandshake: Bool) throws {
        var client: lockdownd_client_t?
        try CAPI<Error>.check(
            (performHandshake ? lockdownd_client_new_with_handshake : lockdownd_client_new)(
                device.raw, &client, strdup(label)
            )
        )
        guard let raw = client else { throw Error.internal }
        self.raw = raw
    }
    deinit { lockdownd_client_free(raw) }

    public func setLabel(_ label: String?) {
        lockdownd_client_set_label(raw, label)
    }

    public func deviceUDID() throws -> String {
        var rawUDID: UnsafeMutablePointer<Int8>?
        try CAPI<Error>.check(lockdownd_get_device_udid(raw, &rawUDID))
        guard let udid = rawUDID else { throw Error.internal }
        return String(cString: udid)
    }

    public func deviceName() throws -> String {
        var rawName: UnsafeMutablePointer<Int8>?
        try CAPI<Error>.check(lockdownd_get_device_name(raw, &rawName))
        guard let name = rawName else { throw Error.internal }
        return String(cString: name)
    }

    public func queryType() throws -> String {
        var rawType: UnsafeMutablePointer<Int8>?
        try CAPI<Error>.check(lockdownd_query_type(raw, &rawType))
        guard let type = rawType.map({ String(cString: $0) })
            else { throw Error.internal }
        return type
    }

    public func syncDataClasses() throws -> [String] {
        try CAPI<Error>.getArrayWithCount(
            parseFn: { lockdownd_get_sync_data_classes(raw, &$0, &$1) },
            freeFn: { lockdownd_data_classes_free($0) }
        ) ?? []
    }

    public func value<T: Decodable>(ofType type: T.Type, forDomain domain: String?, key: String?) throws -> T {
        try decoder.decode(type) {
            try CAPI<Error>.check(lockdownd_get_value(raw, domain, key, &$0))
        }
    }

    public func setValue<T: Encodable>(_ value: T?, forDomain domain: String, key: String) throws {
        if let value = value {
            try CAPI<Error>.check(encoder.withEncoded(value) {
                lockdownd_set_value(raw, domain, key, plist_copy($0))
            })
        } else {
            try CAPI<Error>.check(lockdownd_remove_value(raw, domain, key))
        }
    }

    public func startService<T: LockdownService>(
        ofType type: T.Type = T.self,
        sendEscrowBag: Bool = false
    ) throws -> ServiceDescriptor<T> {
        try ServiceDescriptor(client: self, sendEscrowBag: sendEscrowBag)
    }

    public func startSession(
        withHostID hostID: String
    ) throws -> (sessionID: SessionID, isSSLEnabled: Bool) {
        var rawSessionID: UnsafeMutablePointer<Int8>?
        var isSSLEnabled: Int32 = 0
        try CAPI<Error>.check(lockdownd_start_session(raw, hostID, &rawSessionID, &isSSLEnabled))
        guard let sessionID = rawSessionID else { throw Error.internal }
        return (.init(rawValue: .init(cString: sessionID)), isSSLEnabled != 0)
    }

    public func stopSession(_ sessionID: SessionID) throws {
        try CAPI<Error>.check(lockdownd_stop_session(raw, sessionID.rawValue))
    }

    public func send<T: Encodable>(_ value: T) throws {
        try CAPI<Error>.check(encoder.withEncoded(value) {
            lockdownd_send(raw, $0)
        })
    }

    public func receive<T: Decodable>(_ type: T.Type) throws -> T {
        try decoder.decode(type) {
            try CAPI<Error>.check(lockdownd_receive(raw, &$0))
        }
    }

    public func pair<D: Decodable>(
        withRecord record: PairRecord?,
        returnType: D.Type,
        options: [String: Encodable] = ["ExtendedPairingErrors": true]
    ) throws -> D {
        try decoder.decode(returnType) { buf in
            try CAPI<Error>.check(encoder.withEncoded(options.mapValues(AnyEncodable.init)) {
                lockdownd_pair_with_options(raw, record?.raw, $0, &buf)
            })
        }
    }

    public func validate(record: PairRecord) throws {
        try CAPI<Error>.check(lockdownd_validate_pair(raw, record.raw))
    }

    public func unpair(withRecord record: PairRecord) throws {
        try CAPI<Error>.check(lockdownd_unpair(raw, record.raw))
    }

    public func activate(withActivationRecord record: [String: Encodable]) throws {
        try CAPI<Error>.check(encoder.withEncoded(record.mapValues(AnyEncodable.init)) {
            lockdownd_activate(raw, $0)
        })
    }

    public func deactivate() throws {
        try CAPI<Error>.check(lockdownd_deactivate(raw))
    }

    public func enterRecovery() throws {
        try CAPI<Error>.check(lockdownd_enter_recovery(raw))
    }

    public func sendGoodbye() throws {
        try CAPI<Error>.check(lockdownd_goodbye(raw))
    }

}