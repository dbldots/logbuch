app = angular.module(GLOBALS.ANGULAR_APP_NAME)

app.run ($ionicPickerI18n) ->
  $ionicPickerI18n.weekdays = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]
  $ionicPickerI18n.months = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
  $ionicPickerI18n.ok = "OK"
  $ionicPickerI18n.cancel = "Abbrechen"

app.run ($templateCache) ->
  $templateCache.put 'lib/ion-datetime-picker/src/picker-popup.html', """
    <div class="ion-datetime-picker">
      <div ng-if-start="dateEnabled" class="row month-year">
          <div class="col col-10 left-arrow">
              <button type="button" class="button button-small button-positive button-clear icon ion-chevron-left" ng-click="changeBy(-monthStep, 'month')"></button>
          </div>
          <label class="col col-50 month-input">
              <div class="item item-input item-select">
                  <select ng-model="bind.month" ng-options="i18n.months.indexOf(month) as month for month in i18n.months" ng-change="change('month')"></select>
              </div>
          </label>
          <label class="col year-input">
              <div class="item item-input">
                  <div>
                      <input type="number" ng-model="bind.year" min="1900" max="2999" ng-change="change('year')" ng-blur="changed()" required>
                  </div>
              </div>
          </label>
          <div class="col col-10 right-arrow">
              <button type="button" class="button button-small button-positive button-clear icon ion-chevron-right" ng-click="changeBy(+monthStep, 'month')"></button>
          </div>
      </div>

      <div class="row calendar weekdays">
          <div class="col" ng-repeat="weekday in weekdays">
              <div class="weekday">{{i18n.weekdays[weekday]}}</div>
          </div>
      </div>
      <div ng-if-end class="row calendar days" ng-repeat="y in rows">
          <div class="col" ng-repeat="x in cols">
              <div ng-show="(cellDay = y * 7 + x - firstDay) > 0 && cellDay <= daysInMonth"
                   ng-click="changeDay(cellDay)" class="day"
                   ng-class="{ 'disabled': !isEnabled(cellDay), 'selected': cellDay === day, 'today': cellDay === today.day && month === today.month && year === today.year }">
                  {{cellDay}}
              </div>
          </div>
      </div>

      <div ng-if-start="timeEnabled" class="row time-buttons">
          <div class="col"></div>
          <div class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-up" ng-click="changeBy(+hourStep, 'hour')"></button></div>
          <div class="col"></div>
          <div class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-up" ng-click="changeBy(+minuteStep, 'minute')"></button></div>
          <div ng-if-start="secondsEnabled" class="col"></div>
          <div ng-if-end class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-up" ng-click="changeBy(+secondStep, 'second')"></button></div>
          <div ng-if-start="meridiemEnabled" class="col"></div>
          <div ng-if-end class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-up" ng-click="changeBy(+12, 'hour')"></button></div>
          <div class="col"></div>
      </div>
      <div class="row time">
          <div class="col"></div>
          <label class="col col-20">
              <div class="item item-input">
                  <div>
                      <input type="text" ng-model="bind.hour" pattern="0?([01]?[0-9]|2[0-3])" ng-change="change('hour')" ng-blur="changed()" required>
                  </div>
              </div>
          </label>
          <div class="col colon">:</div>
          <label class="col col-20">
              <div class="item item-input">
                  <div>
                      <input type="text" ng-model="bind.minute" pattern="0?[0-5]?[0-9]" ng-change="change('minute')" ng-blur="changed()" required>
                  </div>
              </div>
          </label>
          <div ng-if-start="secondsEnabled" class="col colon">:</div>
          <label ng-if-end class="col col-20">
              <div class="item item-input">
                  <div>
                      <input type="text" ng-model="bind.second" pattern="0?[0-5]?[0-9]" ng-change="change('second')" ng-blur="changed()" required>
                  </div>
              </div>
          </label>
          <div ng-if-start="meridiemEnabled" class="col"></div>
          <label ng-if-end class="col col-20">
              <div class="item item-input">
                  <div>
                      <input type="text" ng-model="bind.meridiem" pattern="[aApP][mM]" ng-change="change('meridiem')" ng-blur="changed()" required>
                  </div>
              </div>
          </label>
          <div class="col"></div>
      </div>
      <div ng-if-end class="row time-buttons">
          <div class="col"></div>
          <div class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-down" ng-click="changeBy(-hourStep, 'hour')"></button></div>
          <div class="col"></div>
          <div class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-down" ng-click="changeBy(-minuteStep, 'minute')"></button></div>
          <div ng-if-start="secondsEnabled" class="col"></div>
          <div ng-if-end class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-down" ng-click="changeBy(-secondStep, 'second')"></button></div>
          <div ng-if-start="meridiemEnabled" class="col"></div>
          <div ng-if-end class="col-20"><button type="button" class="button button-positive button-clear icon ion-chevron-down" ng-click="changeBy(-12, 'hour')"></button></div>
          <div class="col"></div>
      </div>
  </div>
  """
