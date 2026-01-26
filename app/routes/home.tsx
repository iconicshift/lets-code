import { useTranslation } from "react-i18next";

import { database } from "~/database/context";
import i18n from "~/i18n";
import type { Route } from "./+types/home";
import { formatDateTime } from "~/lib/datetime";

export function meta({}: Route.MetaArgs) {
  const t = i18n.t.bind(i18n);
  return [
    { title: t("common.appName") },
    { name: "description", content: t("common.description") },
  ];
}

export async function loader({ context }: Route.LoaderArgs) {
  const db = database();
  const result = await db.execute<{ now: Date }>("select now()");
  return { csrfToken: context.csrfToken, serverTime: result[0].now };
}

export default function Home({ loaderData }: Route.ComponentProps) {
  const { t } = useTranslation();

  return (
    <main className="flex items-center justify-center min-h-screen">
      <div className="text-center space-y-4">
        <h1 className="text-4xl font-bold">{t("common.appName")}</h1>
        <p className="text-gray-600 dark:text-gray-400">
          {t("home.dbConnected", {
            time: formatDateTime(new Date(loaderData.serverTime)),
          })}
        </p>
      </div>
    </main>
  );
}
