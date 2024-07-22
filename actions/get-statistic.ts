
import { auth } from '@clerk/nextjs';
import { Link } from '@prisma/client';
import prismadb from '@/lib/prismadb';
import { notFound } from 'next/navigation';

interface StatisticData {
  totalLinks: number;
  totalHits: number;
  topLink: Link | null;
  topCountry: string | undefined;
}

export const getStatistic = async (): Promise<StatisticData> => {
  const { userId } = auth();

  if (!userId) {
    notFound();
  }

  const [totalLinks, totalHits, topLink, country] = await prismadb.$transaction(
    [
      prismadb.link.count({
        where: {
          userId
        }
      }),
      prismadb.log.count({
        where: {
          link: {
            userId
          }
        }
      }),
      prismadb.link.findFirst({
        where: {
          userId
        },
        orderBy: {
          click: 'desc'
        }
      }),
      prismadb.log.groupBy({
        take: 1,
        by: ['countryCode'],
        where: {
          link: {
            userId: userId
          }
        },
        _count: {
          _all: true
        },
        orderBy: {
          _count: {
            countryCode: 'desc'
          }
        }
      })
    ]
  );

  const regionName = new Intl.DisplayNames(['en'], { type: 'region' });

  console.log('Country:', country);

  const validCountryCode = (code: string) => {
    // Validate the country code using a regex or a list of valid country codes
    const validCodes = ['US', 'IN', 'FR', 'DE', /* add more valid country codes here */];
    return validCodes.includes(code);
  };

  const topCountry =
    country.length > 0 && validCountryCode(country[0].countryCode)
      ? regionName.of(country[0].countryCode)
      : 'N/A';

  return { totalLinks, totalHits, topLink, topCountry };
};
