# Bookmark

make proj with db that stores bookmark, code, url, name

~~index action looks up shortcode from the route~~

~~build form to save url to db~~

~~User can copy shortcode url and browser will redirect~~

~~user auth~~

~~Delete button for index view~~
  ~~scoped by user~~
  ~~guard against nil user~~

~~Ability for a user to set a bookmark as public/private~~

~~order by inserted_at descending/ascending~~

A list page showing all of the most recent bookmarks (like a feed)

A list page showing the top 20 most popular links calculated by clicks
  Dropdown to sort links by All, Current User, Top 20

Pagination

A details page for a bookmark so a user can see what kind of analytics exist for a bookmark. (How many times it's been clicked mostly, maybe even a time series breakdown of popular times of day it's used)

Ability to archive a bookmark. An archived bookmark can no longer have it's shortcode link be used, but analytics are visible.

Ability to deactivate a bookmark temporarily, and reactive a deactivated bookmark.

Ability to "copy to clipboard" javascript button. (mega difficulty)

Ability to invalidate a short code and generate a new one for a bookmark. Analytics pages can show usages based on shortcodes.


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
