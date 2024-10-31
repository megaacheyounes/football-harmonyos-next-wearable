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

  static getFutureDate(days:number): string {
    const today = new Date();
    const futureDate = new Date(today.getTime() + days * 24 * 60 * 60 * 1000);

    return DateUtils.formatDate(futureDate)
  }

}