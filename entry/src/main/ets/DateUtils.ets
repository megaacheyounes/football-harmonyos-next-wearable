export interface MatchDateTime {
  time: string
  day: string
  timezone: string
}

export class DateUtils {
  static formatDate = (date: Date) => {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2,
      '0');
    return `${year}-${month}-${day}`;
  };

  static getTodayDate(): string {
    const today = new Date();
    return DateUtils.formatDate(today)
  }

  static getFutureDate(days: number): string {
    const today = new Date();
    const futureDate = new Date(today.getTime() + days * 24 * 60 * 60 * 1000);

    return DateUtils.formatDate(futureDate)
  }

  static getDisplayMatchTime(utcDate: string): MatchDateTime {
    const date = new Date(utcDate);

    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');

    const timeZone = date.toLocaleTimeString('en-us', { timeZoneName: 'short' }).split(' ')[2];

    const month = date.toLocaleString('en-us', { month: 'short' });
    const day = date.getDate();

    return {
      day: `${month} ${day}`,
      time: `${hours}:${minutes}`,
      timezone: timeZone
    }
  }
}