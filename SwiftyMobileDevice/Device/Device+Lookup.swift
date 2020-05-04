//
//  Device+Lookup.swift
//  SwiftyMobileDevice
//
//  Created by Kabir Oberai on 28/04/20.
//  Copyright © 2020 Kabir Oberai. All rights reserved.
//

import Foundation

extension Device {

    public struct Event {
        public enum EventType {
            case add
            case remove
            case paired

            public var raw: idevice_event_type {
                switch self {
                case .add: return IDEVICE_DEVICE_ADD
                case .remove: return IDEVICE_DEVICE_REMOVE
                case .paired: return IDEVICE_DEVICE_PAIRED
                }
            }

            public init?(_ raw: idevice_event_type) {
                switch raw {
                case IDEVICE_DEVICE_ADD: self = .add
                case IDEVICE_DEVICE_REMOVE: self = .remove
                case IDEVICE_DEVICE_PAIRED: self = .paired
                default: return nil
                }
            }
        }

        public enum ConnectionType: Int {
            case usbmuxd = 1
        }

        public let eventType: EventType
        public let udid: String
        public let connectionType: ConnectionType

        public init?(raw: idevice_event_t) {
            guard let eventType = EventType(raw.event),
                let connectionType = ConnectionType(rawValue: Int(raw.conn_type))
                else { return nil }
            self.eventType = eventType
            self.udid = String(cString: raw.udid)
            self.connectionType = connectionType
        }
    }

    public class SubscriptionToken {
        fileprivate init() {}
    }

    public static func udids() throws -> [String] {
        try CAPI<Error>.getArrayWithCount(
            parseFn: { idevice_get_device_list(&$0, &$1) },
            freeFn: { idevice_device_list_free($0) }
        ) ?? []
    }

    private static var subscriptionLock = NSLock()
    private static var subscribers: [ObjectIdentifier: (Event) -> Void] = [:]
    private static var isSubscribed = false

    private static func actuallySubscribeIfNeeded() {
        guard !isSubscribed else { return }
        isSubscribed = true
        idevice_event_subscribe({ eventPointer, _ in
            guard let rawEvent = eventPointer?.pointee,
                let event = Event(raw: rawEvent)
                else { return }
            Device.subscribers.values.forEach { $0(event) }
        }, nil)
    }

    public static func subscribe(callback: @escaping (Event) -> Void) -> SubscriptionToken {
        subscriptionLock.lock()
        defer { subscriptionLock.unlock() }
        actuallySubscribeIfNeeded()
        let token = SubscriptionToken()
        subscribers[ObjectIdentifier(token)] = callback
        return token
    }

    public static func unsubscribe(token: SubscriptionToken) {
        subscriptionLock.lock()
        defer { subscriptionLock.unlock() }

        subscribers.removeValue(forKey: ObjectIdentifier(token))

        if subscribers.isEmpty {
            idevice_event_unsubscribe()
            isSubscribed = false
        }
    }

}
