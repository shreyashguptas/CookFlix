-- Description: This file contains the current database schema for the recipe app.

-- Recipes table
create table recipes (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  summary text,
  image_name text,
  preparation_time text,
  cooking_time text,
  servings text,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  user_id uuid references auth.users(id)
);

-- Enable RLS on tables
alter table recipes enable row level security;

-- Create policies for recipes table
create policy "Users can view their own recipes"
on recipes for select
using (auth.uid() = user_id);

create policy "Users can create their own recipes"
on recipes for insert
with check (auth.uid() = user_id);

create policy "Users can update their own recipes"
on recipes for update
using (auth.uid() = user_id);

create policy "Users can delete their own recipes"
on recipes for delete
using (auth.uid() = user_id);

-- Ingredients table
create table ingredients (
  id uuid primary key default uuid_generate_v4(),
  recipe_id uuid references recipes(id) on delete cascade,
  name text not null,
  quantity double precision not null,
  unit text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Enable RLS on tables
alter table ingredients enable row level security;

-- Create policies for ingredients table
create policy "Users can view ingredients of their recipes"
on ingredients for select
using (
    exists (
        select 1 from recipes
        where recipes.id = ingredients.recipe_id
        and recipes.user_id = auth.uid()
    )
);

create policy "Users can create ingredients for their recipes"
on ingredients for insert
with check (
    exists (
        select 1 from recipes
        where recipes.id = ingredients.recipe_id
        and recipes.user_id = auth.uid()
    )
);

create policy "Users can update ingredients of their recipes"
on ingredients for update
using (
    exists (
        select 1 from recipes
        where recipes.id = ingredients.recipe_id
        and recipes.user_id = auth.uid()
    )
);

create policy "Users can delete ingredients of their recipes"
on ingredients for delete
using (
    exists (
        select 1 from recipes
        where recipes.id = ingredients.recipe_id
        and recipes.user_id = auth.uid()
    )
);

-- Instructions table
create table instructions (
  id uuid primary key default uuid_generate_v4(),
  recipe_id uuid references recipes(id) on delete cascade,
  step_number integer not null,
  instruction text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Enable RLS on tables
alter table instructions enable row level security;

-- Create policies for instructions table
create policy "Users can view instructions of their recipes"
on instructions for select
using (
    exists (
        select 1 from recipes
        where recipes.id = instructions.recipe_id
        and recipes.user_id = auth.uid()
    )
);

create policy "Users can create instructions for their recipes"
on instructions for insert
with check (
    exists (
        select 1 from recipes
        where recipes.id = instructions.recipe_id
        and recipes.user_id = auth.uid()
    )
);

create policy "Users can update instructions of their recipes"
on instructions for update
using (
    exists (
        select 1 from recipes
        where recipes.id = instructions.recipe_id
        and recipes.user_id = auth.uid()
    )
);

create policy "Users can delete instructions of their recipes"
on instructions for delete
using (
    exists (
        select 1 from recipes
        where recipes.id = instructions.recipe_id
        and recipes.user_id = auth.uid()
    )
);