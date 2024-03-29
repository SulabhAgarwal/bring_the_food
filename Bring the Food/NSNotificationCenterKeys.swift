//
//  NSNotificationCenterKeys.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 03/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation

// rest notifications - "DONATIONS" section
public let donationCreatedNotificationKey = "donationCreatedResponse"
public let donationDeletedNotificationKey = "donationDeletedResponse"
public let getSingleDonationNotificationKey = "getSingleDonationResponse"
public let getOthersDonationNotificationKey = "getOthersDonationResponse"
public let getMyDonationNotificationKey = "getMyDonationResponse"
public let getBookingsNotificationKey = "getBookingsReponse"


// rest notifications - "BOOKINGS" section

// rest notifications - "USER" section
public let loginResponseNotificationKey = "loginResponse"
public let logoutResponseNotificationKey = "logoutResponse"
public let mailAvailabilityResponseNotificationKey = "mailAvailabilityResponse"
public let registrationResponseNotificationKey = "registrationResponse"
public let userInfoResponseNotificationKey = "userInfoResponse"
public let getSettingsResponseNotificationKey = "getSettingsResponse"

// rest notifications - "NOTIFICATIONS" section
public let getNotificationsResponseNotificationKey = "getNotificationsResponse"


public let imageDownloadNotificationKey = "imageDownload"