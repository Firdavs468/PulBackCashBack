//
//  AppLanguage.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 30/11/21.
//

import Foundation
class AppLanguage {
    class func getTitle(type:Languages) -> String {
        let langugae = Cache.getUserDefaultsString(forKey: Keys.language)
        
        if langugae == "uz" {
            return getUzValue(type: type)
        }else {
            return getRusValue(type: type)
        }
    }
}

//language = uz
extension AppLanguage {
    private class func getUzValue(type:Languages) -> String {
        switch type {
            
            case .letsGoLbl:
                return "Nima bopti? Qani ketdik!"
            case .mobileNumberLbl:
                return "Mobil telefon raqami"
            case .loginSmsLbl:
                return "Sizga login kodi bilan SMS keladi"
            case .userAgreementLbl:
                return "en foydalanuvchi shartnomasiga roziman va shaxsiy ma'lumotlarni qayta ishlashga roziman"
            case .agreeLbl:
                return "Men aksiyalar, chegirmalar va boshqa reklama e'lonlari haqidagi xabarlarni olishga roziman Tiin bozori"
            case .confirmationLbl:
                return "Tasdiqlash"
            case .phoneNumberLbl:
                return "Mobil raqami"
            case .smsCodeLbl:
                return "SMS kodi"
            case .otpTimerLbl:
                return "Kodni yuborish uchun qolgan vaqtingiz:"
            case .confirmationCodePlc:
                return "Tasdiqlash kodi"
            case .profileLbl:
                return "Profil"
            case .cashBackCardLbl:
                return "Cashback kartasi virtual bo'lib, uning jismoniy hamkasbi yo'q. Virtual kartadan faqat ushbu ilova orqali foydalanish mumkin."
            case .requiredFieldsLbl:
                return "(*) bilan belgilangan maydonlar shart"
            case .proccedLbl:
                return " Davom etish"
            case .namePlc:
                return "Ism"
            case .surnamePlc:
                return "Familia"
            case .birthdayPlc:
                return "Tug'ilgan kun"
            case .genderPlc:
                return "Jins"
            case .familyStatusPlc:
                return "Oilaviy xolat"
            case .pinNav:
                return "Pin kod"
            case .enterPasswordLbl:
                return "Parol kiting "
            case .goodDayLbl:
                return "Hayrli kun"
            case .myBalanceLbl:
                return "Sizning balansingizda : "
            case .showCodeLbl:
                return "Kodni ko'rsatish"
            case .openBeetoBtn:
                return "     Boshlash orqali xarid qilish"
            case .bonusesBtn:
                return "Bonuslar"
            case .purchasesBtn:
                return "Xaridlar"
            case .branchesNav:
                return "Filial"
            case .newsNav:
                return "Yangiliklar"
            case .continueRouteBtn:
                return "Marshrut orqali"
            case .openLbl:
                return "Ochiq"
            case .closeLbl:
                return "Yopiladi: "
            case .scanBtn:
                return "Skanerlash"
            case .oneClickBtn:
                return "Bir marta bosish bilan sotib oling"
            case .myProfileTiinLbl:
                return "Mening Tiin dagi profilim"
            case .SupportLbl:
                return "Qo'llab quvvatlash markazi"
            case .myProfileNav:
                return "Profil"
            case .useTouchIdLbl:
                return " Touch ID dan foydalaning"
            case .touchIdLbl:
                return "Ilovaga tezda kirish uchun Touch ID ishlatilsinmi?"
            case .settingsNav:
                return "Sozlamalar"
            case .feedBackFieldLbl:
                return " Sizning har qanday fikr-mulohazangiz biz uchun muhim. (*) bilan belgilangan maydonlar shart."
            case .reviewsNav:
                return "Sharhlar"
            case .messagePlc:
                return "Xabar*"
            case .sendBtn:
                return "Yuborish"
            case .sendAgainBtn:
                return "Yana bir marta yuborish"
            case .homeTitle:
                return "Asosiy"
            case .filialTitle:
                return "Filiallar"
            case .newsTitle:
                return "Yangiliklar"
            case .profileTitle:
                return "Profil"
            case .feedBackTypeAlertTitle:
                return "Aloqa turi"
            case .choosePlaceAlertTitle:
                return "Joyni tanlang"
            case .feedBackSuccess:
                return "Fikringiz muvafaqiyatli yetkazildi"
            case .profileUpdateNav:
                return "Profil"
            case .profileRequiredLbl:
                return "(*) bilan belgilangan maydonlar shart"
            case .profilePhotoPlc:
                return "Rasmni tanlang"
        }
    }
}

// langugae = russian
extension AppLanguage {
    private class func getRusValue(type:Languages) -> String {
        switch type {
            
            case .letsGoLbl:
                return "Ну что? Погнали!"
            case .mobileNumberLbl:
                return "Номер мобильного"
            case .loginSmsLbl:
                return "Вы получите СМС с кодом для входа"
            case .userAgreementLbl:
                return "Я согласен с Пользовательским соглашением и даю согласие на обработку персональных данных"
            case .agreeLbl:
                return "Я согласен с на получение сообшений об акциях, скидках и других рекламных уведомлений Tiin Market"
            case .confirmationLbl:
                return "Подтверждение"
            case .phoneNumberLbl:
                return "Номер мобильного"
            case .smsCodeLbl:
                return "Код из СМС"
            case .otpTimerLbl:
                return "Повторно отправить код можно через: "
            case .confirmationCodePlc:
                return "Код подтверждения"
            case .profileLbl:
                return "Профиль"
            case .cashBackCardLbl:
                return "Кешбек карта виртульной и не имеет физического аналога. Виртуальная карта доступна для пользования только через данное приложение.При регистрации карты просим ва вводить реальные данные, поскольку они могут быть использованы для идентификации владельца карты в случае ее утерии."
            case .requiredFieldsLbl:
                return "Поля, отмеченные (*), обязательны для заполнения"
            case .proccedLbl:
                return "Продолжить"
            case .namePlc:
                return "Имя * "
            case .surnamePlc:
                return "Фамилия *"
            case .birthdayPlc:
                return "Дата рождения * "
            case .genderPlc:
                return "Пол"
            case .familyStatusPlc:
                return "Семеное положение"
            case .pinNav:
                return "ПИН-код"
            case .enterPasswordLbl:
                return "Введите пароль"
            case .goodDayLbl:
                return "Добрый день,"
            case .myBalanceLbl:
                return "На вашем балансе:"
            case .showCodeLbl:
                return "Показать код"
            case .openBeetoBtn:
                return "Начните покупки через"
            case .bonusesBtn:
                return "Бонусы"
            case .purchasesBtn:
                return "Покупки"
            case .branchesNav:
                return "Филиалы"
            case .newsNav:
                return "Новости"
            case .continueRouteBtn:
                return "Продолжить маршрут"
            case .openLbl:
                return "Открыт"
            case .closeLbl:
                return "Закрывается в: "
            case .scanBtn:
                return "Сканировать"
            case .oneClickBtn:
                return "          Купить в одинь клик "
            case .myProfileTiinLbl:
                return "Мой пофиль в Tiin"
            case .SupportLbl:
                return "Служба поддержки"
            case .myProfileNav:
                return "Профиль"
            case .useTouchIdLbl:
                return "Использовать Touch ID"
            case .touchIdLbl:
                return "Использовать Touch ID для быстрого входа в приложение?"
            case .settingsNav:
                return "Настройки"
            case .feedBackFieldLbl:
                return "Любой ваш отзыв важен для нас. Поля, отмеченные (*), обязательны для заполнения."
            case .reviewsNav:
                return "Отзывы"
            case .messagePlc:
                return "Сообщение*"
            case .sendBtn:
                return "Отправить"
            case .sendAgainBtn:
                return "Отправить ещё раз"
            case .homeTitle:
                return "Главная"
            case .filialTitle:
                return "Филиалы"
            case .newsTitle:
                return "Новости"
            case .profileTitle :
                return "Профиль"
            case .feedBackTypeAlertTitle:
                return "Тип обратной связи"
            case .choosePlaceAlertTitle:
                return "Выберите местo"
            case .feedBackSuccess:
                return "Идея была успешно отправлена"
            case .profileUpdateNav:
                return "Профиль"
            case .profileRequiredLbl:
                return "Поля, отмеченные (*), обязательные для заполнения"
            case .profilePhotoPlc:
                return "Выбрать изображение"
        }
    }
}

//App languages enum
enum Languages {
    
    //MARK: ----> enter phone number vc
    
    //label text
    case letsGoLbl //lets go
    case mobileNumberLbl ///mobile
    case loginSmsLbl
    case userAgreementLbl
    case agreeLbl
    
    
    //MARK: ----> verification vc
    
    //label text
    case confirmationLbl
    case phoneNumberLbl
    case smsCodeLbl
    case otpTimerLbl
    
    // Text Field Placeholder
    case confirmationCodePlc
    
    //Button title
    case sendAgainBtn
    
    
    
    //MARK: ----> Registration vc
    
    //label text
    case profileLbl
    case cashBackCardLbl
    case requiredFieldsLbl
    case proccedLbl
    
    //text field placeholer
    case namePlc
    case surnamePlc
    case birthdayPlc
    case genderPlc
    case familyStatusPlc
    
    
    //MARK: ----> Pin code vc
    
    //navigation title
    case pinNav
    
    //label text
    case enterPasswordLbl
    
    
    //MARK: ----> Home vc
    
    //label text
    case goodDayLbl
    case myBalanceLbl
    case showCodeLbl
    
    //button title
    case openBeetoBtn
    case bonusesBtn
    case purchasesBtn
    
    
    //MARK: ----> Branches vc
    
    //navigation title
    case branchesNav
    
    
    //MARK: ----> News vc
    
    //navigation title
    case newsNav
    
    //button title
    case continueRouteBtn
    
    //label text
    case openLbl
    case closeLbl
    
    
    //MARK: ----> Products vc
    //button title
    case scanBtn
    case oneClickBtn
    
    
    //MARK: ----> MyProfile vc
    //label text
    case myProfileTiinLbl
    case SupportLbl
    
    //navigation title
    case myProfileNav
    
    
    //MARK: ----> Settings vc
    
    //label text
    case useTouchIdLbl
    case touchIdLbl
    
    // navigation title
    case settingsNav
    
    
    //MARK: ----> Reviews vc
    
    //label text
    case feedBackFieldLbl
    
    //navigation title
    case reviewsNav
    
    //textView placeholder
    case messagePlc
    
    //button title
    case sendBtn
    
    
    //MARK: ----> ProfileUpdate vc
    
    //navigation title
    case profileUpdateNav
    
    //label text
    case profileRequiredLbl //Поля, отмеченные (*), обязательные для заполнения //(*) bilan belgilangan maydonlar shart
    
    
    //placeholer
    case profilePhotoPlc
    
    
    //MARK: ----> Tabbar item title
    case homeTitle
    case filialTitle
    case newsTitle
    case profileTitle
    
    
    //MARK: -----> ALERT
    case feedBackTypeAlertTitle
    case choosePlaceAlertTitle
    
    
    //done lottie
    case feedBackSuccess
    
    
}
