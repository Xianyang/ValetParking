var OrderProfile = function(cnf) {
    this._id = cnf._id,
    this.createAt = cnf.createAt,
    this.userRequestAt = cnf.userRequestAt,
    this.endAt = cnf.endAt,
    this.parkingPlace = cnf.parkingPlace,
    this.userIdentifier = cnf.userIdentifier,
    this.userFirstName = cnf.userFirstName,
    this.userLastName = cnf.userLastName,
    this.userPhone = cnf.userPhone,
    this.carIdentifier = cnf.carIdentifier,
    this.carPlate = cnf.carPlate,
    this.carBrand = cnf.carBrand,
    this.carColor = cnf.carColor
};

module.exports = OrderProfile;

// @property (strong, nonatomic) NSString *identifier;
// @property (strong, nonatomic) NSString *createAt;
// @property (strong, nonatomic) NSString <Optional> *userRequestAt;
// @property (strong, nonatomic) NSString <Optional> *endAt;
//
//
// @property (strong, nonatomic) NSString *parkingPlace;
//
// @property (strong, nonatomic) NSString *userIdentifier;
// @property (strong, nonatomic) NSString *userFirstName;
// @property (strong, nonatomic) NSString *userLastName;
// @property (strong, nonatomic) NSString *userPhone;
//
// @property (strong, nonatomic) NSString *carIdentifier;
// @property (strong, nonatomic) NSString *carPlate;
// @property (strong, nonatomic) NSString *carBrand;
// @property (strong, nonatomic) NSString *carColor;
